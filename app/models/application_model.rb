class ApplicationModel
  include ActiveModel::Model

  DATETIME_FORMAT = '%a, %d %b %Y %T %z'.freeze

  def parse(key, value, obj)
    key[/date_*/] && value ? DateTime.strptime(value, DATETIME_FORMAT) : value
  end

  def update
    raise NotImplementedError
  end

  def delete
    raise NotImplementedError
  end

  class << self
    def all(parameters = {})
      resource.all(parameters).collect(&method(:bc_to_instance))
    end

    def find(id)
      bc_to_instance(resource.find(id))
    end

    def count
      resource.count&.count
    end

    def create(attributes)
      raise NotImplementedError
    end

    private

    def bc_to_instance(bc)
      bc.each_with_object(new) do |(k, v), instance|
        instance.send "#{k}=", instance.parse(k, v, bc) if(instance.respond_to?(k))
      end
    end

    def resource
      @resource ||= "Bigcommerce::#{self.name}".constantize
    end
  end
end
