require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.1.0.tgz"
  sha256 "b56144cc164a4410f8615768b3f894246cba64aad7039648cfbc8e4422aa0ae5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6f22e6dd1afcd3200ab8395c6f1692ed98a0160e29c2a5997e822da1b6c94321"
    sha256 cellar: :any,                 arm64_ventura:  "6f22e6dd1afcd3200ab8395c6f1692ed98a0160e29c2a5997e822da1b6c94321"
    sha256 cellar: :any,                 arm64_monterey: "6f22e6dd1afcd3200ab8395c6f1692ed98a0160e29c2a5997e822da1b6c94321"
    sha256 cellar: :any,                 sonoma:         "a8818fe7d74051bc1cd7379dee1c43e7106c04299f381ba3d5f171799e4f3537"
    sha256 cellar: :any,                 ventura:        "a8818fe7d74051bc1cd7379dee1c43e7106c04299f381ba3d5f171799e4f3537"
    sha256 cellar: :any,                 monterey:       "a8818fe7d74051bc1cd7379dee1c43e7106c04299f381ba3d5f171799e4f3537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0163a976dc7deb59055502cd840f338f249e680ecc11d037776431ad95dc726d"
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