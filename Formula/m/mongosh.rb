require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.0.1.tgz"
  sha256 "36b60bca81660088c361c3422656acb18f5c037a5fbf3489992bef33e4be3d63"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "c38c1a4ae77f3db835c06ef0ef70bdb568a2fe61be2071ef8277cb094cdee90f"
    sha256                               arm64_monterey: "12cf74a7424f06e55ba56830601dc339ff6ff2dc7787a9b39bc7cdbc91f914e9"
    sha256                               arm64_big_sur:  "821e20fc084433cd51ded02328ce55bc0fcd7f8add6614bf4206580df6e656ec"
    sha256                               ventura:        "afdd48e0e07cd6497e390211a314d5f66c6c79cd6cf7bee65022c15d5d268e6e"
    sha256                               monterey:       "efe60c2a14b808904f97af61edd5d83135e252a593bf9879f0694c41334aae0e"
    sha256                               big_sur:        "334d97b62aca31102c97c45cc53c55fd1348b6d4362f196640c851279407de9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c5edbb357dedc606a1971a0073af8b7ba90beaeed29f3e646d661e9a84be10"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end