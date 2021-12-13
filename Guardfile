guard :test, include: ['src'], cli: 'color' do
  watch(%r{^test/.+_test\.rb$})
  watch('test/test_helper.rb')  { 'test' }
  watch(%r{^src/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
end
