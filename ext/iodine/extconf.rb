require 'mkmf'

$CFLAGS = '-std=c11 -O3 -Wall'

abort 'Missing a Linux/Unix OS evented API (epoll/kqueue).' unless have_func('kevent') || have_func('epoll_ctl')

if ENV['CC']
  ENV['CPP'] ||= ENV['CC']
  puts "detected user prefered compiler (#{ENV['CC']})."
elsif find_executable('clang')
  $CC = ENV['CC'] = 'clang'
  $CPP = ENV['CPP'] = 'clang'
  puts 'using clang compiler.'
elsif find_executable('gcc-6')
  $CC = ENV['CC'] = 'gcc-6'
  $CPP = ENV['CPP'] = find_executable('g++-6') ? 'g++-6' : 'gcc-6'
  puts 'using gcc-6 compiler.'
elsif find_executable('gcc-5')
  $CC = ENV['CC'] = 'gcc-5'
  $CPP = ENV['CPP'] = find_executable('g++-5') ? 'g++-5' : 'gcc-5'
  puts 'using gcc-5 compiler.'
elsif find_executable('gcc-4.9')
  $CC = ENV['CC'] = 'gcc-4.9'
  $CPP = ENV['CPP'] = find_executable('g++-4.9') ? 'g++-4.9' : 'gcc-4.9'
  puts 'using gcc-4.9 compiler.'
else
  warn 'unknown / old compiler version - installation might fail.'
end

RbConfig::MAKEFILE_CONFIG['CC'] = $CC = ENV['CC'] if ENV['CC']
RbConfig::MAKEFILE_CONFIG['CPP'] = $CPP = ENV['CPP'] if ENV['CPP']

abort 'Missing support for atomic operations (support for C11) - is your compiler updated?' unless have_header('stdatomic.h')
# abort "Missing OpenSSL." unless have_library("ssl")

create_makefile 'iodine/iodine'
