require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.2.10.tgz"
  sha256 "c4896a3baa97fe3de6dd54ea10a9bd9d78958a311e0d9604422b7e713da663be"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b98067d7ee11870c3f64c7f485098a32378487b2288486fdbbfc501899df199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b98067d7ee11870c3f64c7f485098a32378487b2288486fdbbfc501899df199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b98067d7ee11870c3f64c7f485098a32378487b2288486fdbbfc501899df199"
    sha256 cellar: :any_skip_relocation, ventura:        "36371deb7afdf827faa6519dd7f40b97113587e2482231195d9fc50eb9f17d65"
    sha256 cellar: :any_skip_relocation, monterey:       "36371deb7afdf827faa6519dd7f40b97113587e2482231195d9fc50eb9f17d65"
    sha256 cellar: :any_skip_relocation, big_sur:        "36371deb7afdf827faa6519dd7f40b97113587e2482231195d9fc50eb9f17d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b98067d7ee11870c3f64c7f485098a32378487b2288486fdbbfc501899df199"
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