module Services
  Success = Struct.new(:value)
  Failure = Struct.new(:error_key)

  class Base
    private

    def success(value)
      Success.new(value)
    end

    def failure(key)
      Failure.new(key)
    end
  end
end
