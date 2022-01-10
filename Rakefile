CC = "gcc"

task :default => "test-rake"

file "test-rake" => "test" do
  sh "./test"
end

file "test" => "test.c" do
  sh "#{CC} test.c -o test"
end
