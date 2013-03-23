# guard 'ctags-bundler', :src_path => ['app', 'lib', 'spec/support'] do
#   watch(/^(lib|spec\/support)\/.*\.rb$/)
#   watch('Gemfile.lock')
# end

guard 'rspec', :all_after_pass => false, :all_on_start => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end
