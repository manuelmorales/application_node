maintainer       "Manuel Morales"
maintainer_email "manuelmorales@gmail.com"
license          "Apache 2.0"
description      "Deploys and configures Node.js-based applications"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

# Get the nodejs cookbook at https://github.com/mdxp/nodejs-cookbook
%w{ nodejs }.each do |cb|
  depends cb
end
