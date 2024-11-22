class Base
  def self.perform(**args)
    new(**args).perform
  end
end
