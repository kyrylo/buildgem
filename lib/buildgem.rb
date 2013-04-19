require 'fileutils'
require 'date'

module Buildgem

  # The VERSION file must be in the root directory of the library.
  VERSION_FILE = File.expand_path('../../VERSION', __FILE__)

  VERSION = File.exist?(VERSION_FILE) ?
    File.read(VERSION_FILE).chomp : '(could not find VERSION file)'

  def self.build_gem(name)
    if name
      Gem.new(name)
    else
      puts 'Provide an argument, the gem name. Example: buildgem my_gem'
    end
  end

  class Gem

    def initialize(name)
      @name = name

      FileUtils.mkdir(name)
      Dir.chdir(name)
      FileUtils.mkdir('lib')
      FileUtils.mkdir('spec')

      File.open("lib/#{ name }.rb", 'w') do |f|
        f.write(gem_body)
      end

      File.open('CHANGELOG.md', 'w') do |f|
        f.write(changelog)
      end

      File.open('VERSION', 'w') do |f|
        f.write(version)
      end

      File.open('.gitignore', 'w') do |f|
        f.write(gitignore)
      end

      File.open('Gemfile', 'w') do |f|
        f.write(gemfile)
      end

      File.open('LICENCE', 'w') do |f|
        f.write(licence)
      end

      File.open('Rakefile', 'w') do |f|
        f.write(rakefile)
      end

      File.open('spec/helper.rb', 'w') do |f|
        f.write(spec_helper)
      end

      File.open("spec/#{ name }_spec.rb", 'w') do |f|
        f.write(first_spec)
      end

      File.open("#{ name }.gemspec", 'w') do |f|
        f.write(gemspec)
      end

      File.open("README.md", 'w') do |f|
        f.write(readme)
      end
    end

    private

    def gem_body
      <<-BODY
module #{ capitalize(@name) }

  # The VERSION file must be in the root directory of the library.
  VERSION_FILE = File.expand_path('../../VERSION', __FILE__)

  VERSION = File.exist?(VERSION_FILE) ?
    File.read(VERSION_FILE).chomp : '(could not find VERSION file)'

end
      BODY
    end

    def changelog
      <<-BODY
#{ n = capitalize(@name) } changelog
#{ '=' * n.size }

### v0.0.0 (#{ Date::MONTHNAMES[Date.today.month] } 01, #{ Date.today.year })

* Initial release
      BODY
    end

    def version
      '0.0.0'
    end

    def gitignore
      <<-BODY
*~
*.gem
Gemfile.lock
.rbx
doc/
pkg/
.yardoc/
      BODY
    end

    def gemfile
      <<-BODY
source 'https://rubygems.org'
gemspec
      BODY
    end

    def licence
      <<-BODY
Copyright (C) #{ Date.today.year } Kyrylo Silin

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution.
      BODY
    end

    def rakefile
      <<-'BODY'
def quiet
  ENV['VERBOSE'] ? '' : '-q'
end

def test_files
  paths = FileList['spec/**/*_spec.rb']
  paths.shuffle!.join(' ')
end

desc "Run tests"
task :test do
  exec "bacon -Ispec #{ quiet } #{ test_files }"
end

task :default => :test
      BODY
    end

    def spec_helper
      <<-BODY
require 'bacon'
require 'pry'

require_relative '../lib/#{ @name }'

puts "Ruby: #{ RUBY_VERSION }; #{ capitalize(@name) } version: #{ version }"
      BODY
    end

    def first_spec
      <<-BODY
require_relative 'helper'

describe #{ capitalize(@name) } do
  it "works" do
    true.should == true
  end
end
      BODY
    end

    def gemspec
      <<-BODY
Gem::Specification.new do |s|
  s.name         = '#{ @name }'
  s.version      = File.read('VERSION')
  s.date         = Time.now.strftime('%Y-%m-%d')
  s.summary      = ''
  s.description  = ''
  s.author       = 'Kyrylo Silin'
  s.email        = 'kyrylosilin@gmail.com'
  s.homepage     = 'https://github.com/kyrylo/#{ @name }'
  s.licenses     = 'zlib'

  s.require_path = 'lib'
  s.files        = `git ls-files`.split("\\n")

  s.add_development_dependency 'bacon'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'pry'
end
      BODY
    end

    def readme
      <<-BODY
#{ n = capitalize(@name) }
#{ '=' * n.size }

* Repository: [https://github.com/kyrylo/#{ @name }][repo]

Description
-----------

Installation
------------

    gem install #{ @name }

Synopsis
--------

Limitations
-----------

Credits
-------

Licence
-------

The project uses Zlib licence. See LICENCE file for more information.

[repo]: https://github.com/kyrylo/#{ @name }/ "Home page"
      BODY
    end

    def capitalize(name)
      name[0].capitalize +
        name.gsub(/[_-]./) { |s| s[1].capitalize }.slice(1..-1)
    end

  end

end
