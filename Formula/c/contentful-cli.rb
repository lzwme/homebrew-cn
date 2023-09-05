require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.2.tgz"
  sha256 "325182dd331493356e1ad563ee251d62df3cdbabbe48d5e7c20e3d39b3ff066a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc5bdb06bffb66e52db324def0499dae226084852db3555d7f251a97b053d121"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5bdb06bffb66e52db324def0499dae226084852db3555d7f251a97b053d121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc5bdb06bffb66e52db324def0499dae226084852db3555d7f251a97b053d121"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d479f8e7aa4fca13bd78bcf30e98c0a0b19d48094cd997a0a1045a776e0c90"
    sha256 cellar: :any_skip_relocation, monterey:       "c7d479f8e7aa4fca13bd78bcf30e98c0a0b19d48094cd997a0a1045a776e0c90"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7d479f8e7aa4fca13bd78bcf30e98c0a0b19d48094cd997a0a1045a776e0c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc5bdb06bffb66e52db324def0499dae226084852db3555d7f251a97b053d121"
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