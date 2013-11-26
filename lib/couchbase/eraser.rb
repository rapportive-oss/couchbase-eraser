module Couchbase
  class Eraser
    READ_METHODS = %w(
      get
    ).map(&:to_sym)

    WRITE_METHODS = %w(
      set
      incr
    ).map(&:to_sym)

    attr_reader :client; private :client

    def initialize(client)
      @client = client
      reset_keys!
    end

    def erase_written_keys
      @keys.each do |key|
        client.delete key, :quiet => true
      end
      reset_keys!
    end

    ([:delete] + READ_METHODS).each do |meth|
      meth = meth.to_sym
      define_method meth do |key, *args, &block|
        client.send meth, key, *args, &block
      end
    end

    WRITE_METHODS.each do |meth|
      meth = meth.to_sym
      define_method meth do |key, *args, &block|
        @keys << key
        client.send meth, key, *args, &block
      end
    end

    private
    def reset_keys!
      @keys = Set.new
    end
  end
end
