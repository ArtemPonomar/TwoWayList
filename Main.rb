require "minitest/autorun"

class TwoWayNode
  attr_accessor :value, :next, :previous

  def initialize(value)
    @value = value
  end
end

class TwoWayList
  @head
  @tail

  def push(value)
    new_node = TwoWayNode.new(value)
    if @tail == nil
      @head = new_node
      @tail = new_node
    end
    new_node.previous = @tail
    @tail.next = new_node
    @tail = new_node
  end

  def unshift(value)
    new_node = TwoWayNode.new(value)
    if @head == nil
      @head = new_node
      @tail = new_node
    end
    new_node.next = @head
    @head.previous = new_node
    @head = new_node
  end

  def put_at(index, value)
    current = get_node_at(index)
    new_node = TwoWayNode.new(value)
    if current == nil
      return false
    elsif current == @head
      new_node.next = @head
      @head = new_node
      @head.next.previous = @head
    elsif current == @tail
      new_node.previous = @tail
      @tail =new_node
      @tail.previous.next = @tail
    else
      new_node.previous= current.previous
      new_node.next = current
      current.previous = new_node
      new_node.previous.next = new_node
    end
    return true
  end

  def get_at(index)
    get_node_at(index).value
  end

  def get_all
    result = Array.new
    current = @head
    until current == @tail
      result << current.value
      current = current.next
    end
    result << current.value
  end

  def size
    current = @head
    size = 0
    until current == @tail
      current = current.next
      size += 1
    end
    return size+1
  end

  def delete_at(index)
    current = get_node_at(index)

    if current == nil
      return nil
    elsif current == @head
      @head = current.next
      @head.previous = nil
    elsif current == @tail
      @tail = current.previous
      @tail.next = nil
    else
      current.previous.next = current.next
      current.next.previous = current.previous
    end
  end

  private

  def get_node_at(index)
    current = nil
    if (index >= 0)
      current = @head
      index.times do
        current = current.next
      end
    elsif index < 0
      index = index.abs - 1
      current = @tail
      index.times do
        current = current.previous
      end
    end
    current
  end
end

class Test < Minitest::Test
  def setup
    @list = TwoWayList.new
    @list.push(1)
    @list.push(2)
    @list.push(3)
  end

  def test_get_at
    assert_equal 1, @list.get_at(0)
    assert_equal 1, @list.get_at(-3)
  end

  def test_push
    @list.push(4)
    assert_equal 4, @list.get_at(3)
  end

  def test_unshift
    @list.unshift(0)
    assert_equal 0, @list.get_at(0)
  end

  def test_size
    assert_equal 3, @list.size
  end

  def test_put_at
    @list.put_at(1, 1.5)
    assert_equal 1.5, @list.get_at(1)
  end

  def test_get_all
    assert_equal [1, 2, 3], @list.get_all
  end

  def test_delete_at
    @list.delete_at(1)
    assert_equal [1, 3], @list.get_all
  end
end
