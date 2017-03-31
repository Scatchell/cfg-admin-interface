class Video
  attr_accessor :name, :public_url

  def initialize(name, public_url)
    @name = name
    @public_url = public_url
  end
end
