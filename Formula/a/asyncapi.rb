require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.9.2.tgz"
  sha256 "30c1b87efeaf442faa432f9f086e37568106dbd8f517000e91b8361dc24535cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab5b61d2e3d4ec9839d870af083baf63d0620bf06dc9d71ca1aeddd149de6946"
    sha256 cellar: :any,                 arm64_ventura:  "ab5b61d2e3d4ec9839d870af083baf63d0620bf06dc9d71ca1aeddd149de6946"
    sha256 cellar: :any,                 arm64_monterey: "ab5b61d2e3d4ec9839d870af083baf63d0620bf06dc9d71ca1aeddd149de6946"
    sha256 cellar: :any,                 sonoma:         "b7d8ee98d965cf745d3c1922da46cda9d5700a271e213d0bc4bd643d45545293"
    sha256 cellar: :any,                 ventura:        "b7d8ee98d965cf745d3c1922da46cda9d5700a271e213d0bc4bd643d45545293"
    sha256 cellar: :any,                 monterey:       "b7d8ee98d965cf745d3c1922da46cda9d5700a271e213d0bc4bd643d45545293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42d3e1dc289fe575526d97c7d577c3af411a2371d6903d54a337824ed29d116"
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