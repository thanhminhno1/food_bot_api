class MessageService
  def initialize body, event_type, message_id, account_id
    @body = body
    @event_type = event_type
    @message_id = message_id
    @account_id = account_id
  end

  def chatwork
    ChatWork::Client.new(api_key: ENV["CHATWORK_API_TOKEN"])
  end

  def process
    if @event_type == "message_created"
      if @body.downcase.include? "{menu}"
        process_menu
      elsif @body.downcase.include? "{order}"
        process_order
      elsif @body.downcase.include? "{getlist}"
        get_list
      elsif @body.downcase.include? "{getmenu}"
        get_menu
      end
    elsif @event_type == "message_updated"
      if @body.downcase.include? "{menu}"
        edit_menu
      elsif @body.downcase.include? "{order}"
        edit_order
      end
    end
  end

  def edit_menu
    menu = Menu.today.first
    body = content_to_main_array
    return unless menu
    ActiveRecord::Base.transaction do
      menu.foods.destroy_all
      Order.today.destroy_all
      body = create_food_list body, menu
      chatwork.create_message(room_id: ENV["GROUP"], body: body)
    end
  end

  def edit_order
    order = Order.find_by message_id: @message_id
    return unless order
    body = content_to_main_array
    return order.destroy unless body[1]
    return order.food_orders.destroy_all unless body[2]
    menu = Menu.today.first

    ActiveRecord::Base.transaction do
      order.food_orders.destroy_all
      body = create_order_list body, order
      chatwork.create_message(room_id: ENV["GROUP"], body: body)
    end
  end

  def get_list
    body = content_to_list_array
    menu = Menu.today.first
    return unless menu
    body = "List Order #{menu.created_at.strftime("%d/%m")}"
    menu.orders.each do |order|
      body << " \n#{order.name}:"
      body << order.foods.pluck(:name).join(",")
    end
    chatwork.create_message(room_id: ENV["GROUP"], body: body)
  end

  def get_menu
    menu = Menu.today.first
    return unless menu
    body = print_menu menu
    chatwork.create_message(room_id: ENV["GROUP"], body: body)
  end

  def process_order
    body = content_to_main_array
    menu = Menu.today.first
    return if menu.nil? || !body[2]
    body = create_order_list body, menu.orders.new
    chatwork.create_message(room_id: ENV["GROUP"], body: body)
  end

  def process_menu
    body = content_to_main_array
    return if Menu.today.first || !body[1]
    ActiveRecord::Base.transaction do
      menu = Menu.new message_id: @message_id
      if menu.save
        body = create_food_list body, menu
        chatwork.create_message(room_id: ENV["GROUP"], body: body)
      end
    end
  end

  def create_order_list body, order
    ActiveRecord::Base.transaction do
      order.name = body[1]
      order.chatwork_id = @account_id
      order.message_id = @message_id
      if order.save
        body[2].split(",").each do |item|
          food = order.menu.foods.where number: item
          order.food_orders.create food_id: food.first.id if food.first
        end
      end
    end
    body = "#{order.name}: "+order.foods.pluck(:name).join(",")
  end

  def create_food_list body, menu
    foods = []
    body[1].split(",").each_with_index do | value, index |
      foods << menu.foods.new(number: (index+1), name: value)
    end
    Food.import foods
    print_menu menu
  end

  def print_menu menu
    body = "[info]Menu #{menu.created_at.strftime("%d/%m")}"
    menu.foods.order(:number).each do |food|
      body << "\n #{food.number}) #{food.name}"
    end
    body << <<-HEREDOC
      \n
      Cú pháp đặt cơm (1,2,3 là số thứ tự món ăn): [code]{Order}{Tên người đặt}{1,2,3}[/code]
      Cú pháp lấy danh sách đặt cơm: [code]{getlist}[/code]
      Cú pháp lấy menu: [code]{getmenu}[/code]
      Note: Edit tin nhắn để thay đổi order, Xóa 2 vùng tên người đặt và danh sách món ăn để  hủy order[/info]
    HEREDOC
  end

  def content_to_main_array
    content_to_list_array.split("}{")
  end

  def content_to_list_array
    @body[(@body.index("{")+1)..(@body.rindex("}")-1)]
  end
end
