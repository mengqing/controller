class TestController
  include Lotus::Controller

  action 'Index' do
    expose :xyz

    def call(params)
      @xyz = params[:name]
    end
  end
end

class CallAction
  include Lotus::Action

  def call(params)
    self.status  = 201
    self.body    = 'Hi from TestAction!'
    self.headers.merge!({ 'X-Custom' => 'OK' })
  end
end

class ErrorCallAction
  include Lotus::Action

  def call(params)
    raise
  end
end

class ExposeAction
  include Lotus::Action

  expose :film, :time

  def call(params)
    @film = '400 ASA'
  end
end

class BeforeMethodAction
  include Lotus::Action

  expose :article
  before :set_article, :reverse_article

  def call(params)
  end

  private
  def set_article
    @article = 'Bonjour!'
  end

  def reverse_article
    @article.reverse!
  end
end

class SubclassBeforeMethodAction < BeforeMethodAction
  before :upcase_article

  private
  def upcase_article
    @article.upcase!
  end
end

class ParamsBeforeMethodAction < BeforeMethodAction
  expose :exposed_params

  private
  def set_article(params)
    @exposed_params = params
    @article = super() + params[:bang]
  end
end

class ErrorBeforeMethodAction < BeforeMethodAction
  private
  def set_article
    raise
  end
end

class BeforeBlockAction
  include Lotus::Action

  expose :article
  before { @article = 'Good morning!' }
  before { @article.reverse! }

  def call(params)
  end
end

class YieldBeforeBlockAction < BeforeBlockAction
  expose :yielded_params
  before {|params| @yielded_params = params }
end

class AfterMethodAction
  include Lotus::Action

  expose :egg
  after  :set_egg, :scramble_egg

  def call(params)
  end

  private
  def set_egg
    @egg = 'Egg!'
  end

  def scramble_egg
    @egg = 'gE!g'
  end
end

class SubclassAfterMethodAction < AfterMethodAction
  after :upcase_egg

  private
  def upcase_egg
    @egg.upcase!
  end
end

class ParamsAfterMethodAction < AfterMethodAction
  private
  def scramble_egg(params)
    @egg = super() + params[:question]
  end
end

class ErrorAfterMethodAction < AfterMethodAction
  private
  def set_egg
    raise
  end
end

class AfterBlockAction
  include Lotus::Action

  expose :egg
  after { @egg = 'Coque' }
  after { @egg.reverse! }

  def call(params)
  end
end

class YieldAfterBlockAction < AfterBlockAction
  expose :meaning_of_life_params
  before {|params| @meaning_of_life_params = params }
end

class SessionAction
  include Lotus::Action

  def call(params)
  end
end

class RedirectAction
  include Lotus::Action

  def call(params)
    redirect_to '/destination'
  end
end

class StatusRedirectAction
  include Lotus::Action

  def call(params)
    redirect_to '/destination', status: 301
  end
end

class ClassAttributeTest
  include Lotus::Utils::ClassAttribute

  class_attribute :callbacks, :functions, :values
  self.callbacks = [:a]
  self.values    = [1]
end

class SubclassAttributeTest < ClassAttributeTest
  self.functions = [:x, :y]
end

class GetCookiesAction
  include Lotus::Action

  def call(params)
  end
end

class SetCookiesAction
  include Lotus::Action

  def call(params)
    self.body = 'yo'
    cookies[:foo] = 'yum!'
  end
end

class SetCookiesWithOptionsAction
  include Lotus::Action

  def call(params)
    cookies[:kukki] = { value: 'yum!', domain: 'lotusrb.org', path: '/controller', expires: params[:expires], secure: true, httponly: true }
  end
end

class RemoveCookiesAction
  include Lotus::Action

  def call(params)
    cookies[:rm] = nil
  end
end

class ParamsAction
  include Lotus::Action

  def call(params)
    self.body = params.inspect
  end
end

class Root
  include Lotus::Action

  def call(params)
    self.body = params
    headers.merge!({'X-Test' => 'test'})
  end
end

class AboutController
  include Lotus::Controller

  class Team < Root
  end

  action 'Contacts' do
    def call(params)
      self.body = params
    end
  end
end

class IdentityController
  include Lotus::Controller

  class Action
    include Lotus::Action

    def call(params)
      self.body = params
    end
  end

  Show    = Class.new(Action)
  New     = Class.new(Action)
  Create  = Class.new(Action)
  Edit    = Class.new(Action)
  Update  = Class.new(Action)
  Destroy = Class.new(Action)
end

class FlowersController
  include Lotus::Controller

  class Action
    include Lotus::Action

    def call(params)
      self.body = params
    end
  end

  Index   = Class.new(Action)
  Show    = Class.new(Action)
  New     = Class.new(Action)
  Create  = Class.new(Action)
  Edit    = Class.new(Action)
  Update  = Class.new(Action)
  Destroy = Class.new(Action)
end
