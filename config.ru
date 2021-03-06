class App

  def self.call(env)
    new(env).response
  end

  def initialize(env)
    @env = env
  end

  def response
    if credentials.valid?
      [200, {'Content-Type'=>'text/plain'}, [ENV.fetch("SECRET")]]
    else
      [401, {'Content-Type'=>'image/gif'}, File.open("failed.gif")]
    end
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def credentials
    @credentials ||= Credentials.new(*request.body.read.split(":"))
  end

  def user_agent
    @user_agent ||= UserAgent.new @env.fetch("HTTP_USER_AGENT")
  end

  Credentials = Struct.new(:username, :password) do
    def valid?
      username == ENV.fetch("USERNAME") \
      && password == ENV.fetch("PASSWORD")
    end
  end

  UserAgent = Struct.new(:user_agent) do
    ACCEPTABLE = "Jurassic Systems inc.".freeze
    def valid?
      user_agent == ACCEPTABLE
    end
  end

end

run App
