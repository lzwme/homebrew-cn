require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.10.tgz"
  sha256 "c771d9f52c790c9497b250cd0c6ba189ece677d088ffee414201b62055be1d1e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c14536121e0cd2e94f352f021feb2ff80dd27308c79b475b614103ed4ef9eb0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c14536121e0cd2e94f352f021feb2ff80dd27308c79b475b614103ed4ef9eb0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c14536121e0cd2e94f352f021feb2ff80dd27308c79b475b614103ed4ef9eb0d"
    sha256 cellar: :any_skip_relocation, ventura:        "0814605156c7fa7b88f2acf4341fd24e0b5fb12b53523e48141c2a0a92acf7ef"
    sha256 cellar: :any_skip_relocation, monterey:       "0814605156c7fa7b88f2acf4341fd24e0b5fb12b53523e48141c2a0a92acf7ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "0814605156c7fa7b88f2acf4341fd24e0b5fb12b53523e48141c2a0a92acf7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c14536121e0cd2e94f352f021feb2ff80dd27308c79b475b614103ed4ef9eb0d"
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