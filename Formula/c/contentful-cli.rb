require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.45.tgz"
  sha256 "4e8475cf72e0972db3e3a3bc951a9401d8fddf66bf1ec0106ca779756f6c46e3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f0bcd9e0621d40d5936538745ac930fb7950e1f09d998604dc697aac2022e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f0bcd9e0621d40d5936538745ac930fb7950e1f09d998604dc697aac2022e64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f0bcd9e0621d40d5936538745ac930fb7950e1f09d998604dc697aac2022e64"
    sha256 cellar: :any_skip_relocation, ventura:        "eff72df6f3307f40a82c7dacb402d044c49220d0fd5bdf576931583bb05123dc"
    sha256 cellar: :any_skip_relocation, monterey:       "eff72df6f3307f40a82c7dacb402d044c49220d0fd5bdf576931583bb05123dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff72df6f3307f40a82c7dacb402d044c49220d0fd5bdf576931583bb05123dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f0bcd9e0621d40d5936538745ac930fb7950e1f09d998604dc697aac2022e64"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end