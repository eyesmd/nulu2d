module Nulu

  class Graph

    # Nodes can be arbitrary non-mutable data

    DEFAULT_NODE_LIMIT = 100

    def initialize(node_limit = DEFAULT_NODE_LIMIT, invert_graph = false)
      @node_limit = node_limit
      @connected = Array.new(node_limit) { Array.new(node_limit, invert_graph ? true : false) }
      @nodes = []
      @node_to_index = {}
      @current_index = 0
    end


    def add_node(node)
      raise "Can not add more nodes than the graph's limit #{@node_limit}" if @current_index >= @node_limit
      unless is_node(node)
        @nodes << node
        @node_to_index[node] = @current_index
        @current_index += 1
      end
    end

    # TODO: def remove_node

    def add_edge(node_a, node_b)
      raise "Can not add an edge over non-existant nodes" unless @node_to_index[node_a] && @node_to_index[node_b]
      change_edge(node_a, node_b, true)
    end

    def remove_edge(node_a, node_b)
      raise "Can not remove an edge over non-existant nodes" unless @node_to_index[node_a] && @node_to_index[node_b]
      change_edge(node_a, node_b, false)
    end



    def is_node(candidate_node)
      @nodes.include?(candidate_node)
    end

    def node_count
      @nodes.size
    end

    def nodes
      @nodes
    end

    def is_connected?(node_a, node_b)
      raise "Can not ask connection of non-existant nodes" unless @node_to_index[node_a] && @node_to_index[node_b]
      index_a = @node_to_index[node_a]
      index_b = @node_to_index[node_b]
      @connected[index_a][index_b]
    end

    def each_connected_pair
      (0...self.node_count).each do |i|
        (i...self.node_count).each do |j|
          yield(@nodes[i], @nodes[j]) if @connected[i][j]
        end
      end
    end


    private

    def change_edge(node_a, node_b, value)
      index_a = @node_to_index[node_a]
      index_b = @node_to_index[node_b]
      @connected[index_a][index_b] = value
      @connected[index_b][index_a] = value
    end
  end

end