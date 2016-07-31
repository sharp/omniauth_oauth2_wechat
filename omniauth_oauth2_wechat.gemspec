version = File.read(File.expand_path('../lib/VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'omniauth_oauth2_wechat'
  s.version     = version
  s.summary     = 'Omniauth strategy for wechat(weixin)'
  s.description = 'Using OAuth2 to authenticate wechat user when web resources being viewed within wechat(weixin) client.'

  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.23'

  s.author       = 'sharp'
  s.email        = 'liuqiang_0701@163.com'
  s.homepage     = 'https://github.com/sharp/omniauth_oauth2_wechat'

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_dependency 'omniauth-oauth2', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 2.7'
end
