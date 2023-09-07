require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.5.tgz"
  sha256 "0f98ea2e512aedb9c9f3777207f984da035b90435ca7452002a33cb5788d9a73"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d915a3f4fb9c584fbd86f42d358753eb9a49c0aa680f988681150c063b2bf93a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d915a3f4fb9c584fbd86f42d358753eb9a49c0aa680f988681150c063b2bf93a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d915a3f4fb9c584fbd86f42d358753eb9a49c0aa680f988681150c063b2bf93a"
    sha256 cellar: :any_skip_relocation, ventura:        "287b974288187cd3b3b0ff67cbf5a22763196a2543dcbc5d83f8bc53c9f1bde3"
    sha256 cellar: :any_skip_relocation, monterey:       "287b974288187cd3b3b0ff67cbf5a22763196a2543dcbc5d83f8bc53c9f1bde3"
    sha256 cellar: :any_skip_relocation, big_sur:        "287b974288187cd3b3b0ff67cbf5a22763196a2543dcbc5d83f8bc53c9f1bde3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d915a3f4fb9c584fbd86f42d358753eb9a49c0aa680f988681150c063b2bf93a"
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