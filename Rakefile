# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'ffi-life/version'

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

CLOBBER << '*~' << '*.*~'

PROJ.name = 'ffi-life'
PROJ.authors = 'Andrea Fazzi'
PROJ.email = 'andrea.fazzi@alcacoop.it'
PROJ.url = 'http://github.com/remogatto/ffi-life'
PROJ.version = Life::VERSION

PROJ.readme_file = 'README.rdoc'

PROJ.ann.paragraphs << 'FEATURES' << 'SYNOPSIS' << 'REQUIREMENTS' << 'DOWNLOAD/INSTALL' << 'BENCHMARKS'
PROJ.ann.email[:from] = 'andrea.fazzi@alcacoop.it'
PROJ.ann.email[:to] << 'dev@ruby-ffi.kenai.com' << 'users@ruby-ffi.kenai.com'
PROJ.ann.email[:server] = 'smtp.gmail.com'

PROJ.spec.opts << '--color' << '-fs'

PROJ.ruby_opts = []

depend_on 'ffi-inliner', '0.2.1'

task :default => 'spec'

# EOF
