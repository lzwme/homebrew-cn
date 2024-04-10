require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.8.2.tgz"
  sha256 "8fde6e0bc034c26068e873d05fa57fbdb987355c6d791cad766ed0e8d481d940"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fc69687157c304e60262c72d0fca79af8793f2ce72df789cb1a83635259481a3"
    sha256 cellar: :any,                 arm64_ventura:  "fc69687157c304e60262c72d0fca79af8793f2ce72df789cb1a83635259481a3"
    sha256 cellar: :any,                 arm64_monterey: "fc69687157c304e60262c72d0fca79af8793f2ce72df789cb1a83635259481a3"
    sha256 cellar: :any,                 sonoma:         "6feb909728af1069e471dfb7ac1a2c81cc1cae53e16c557991085949c13bb0fd"
    sha256 cellar: :any,                 ventura:        "6feb909728af1069e471dfb7ac1a2c81cc1cae53e16c557991085949c13bb0fd"
    sha256 cellar: :any,                 monterey:       "6feb909728af1069e471dfb7ac1a2c81cc1cae53e16c557991085949c13bb0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260e39cf669bc6f23f87e0c4c1a511f7880a09f23fdfe38e94f3b6f55a95f9c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end