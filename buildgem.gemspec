Gem::Specification.new do |s|
  s.name         = 'buildgem'
  s.version      = File.read('VERSION')
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = "Kyrylo's personal template for a gem"
  s.description  = 'It is not a general purpose library'
  s.author       = 'Kyrylo Silin'
  s.email        = 'kyrylosilin@gmail.com'
  s.homepage     = 'https://github.com/kyrylo/buildgem'
  s.licenses     = 'zlib'

  s.files        = `git ls-files`.split("\n")
  s.bindir       = 'bin'
  s.require_path = 'lib'
  s.executable   = 'buildgem'
end
