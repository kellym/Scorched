module Scorched
  class Response < Rack::Response
    # Merges another response object (or response array) into self in order to preserve references to this response
    # object.
    def merge!(response)
      return self if response == self
      if Rack::Response === response
        response.finish
        self.status = response.status
        self.header.merge!(response.header)
        self.body = []
        response.each { |v| self.body << v }
      else
        self.status, @header, self.body = response
      end
    end
    
    # Automatically wraps the assigned value in an array if it doesn't respond to ``each``.
    # Also filters out non-true values and empty strings.
    def body=(value)
      value = []  if !value || value == ''
      super(value.respond_to?(:each) ? value : [value.to_s])
    end
    
    def finish(*args, &block)
      self['Content-Type'] ||= 'text/html;charset=utf-8'
      super
    end
    
    alias :to_a :finish
    alias :to_ary :finish
  end
end