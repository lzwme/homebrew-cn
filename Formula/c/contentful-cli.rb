require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.10.tgz"
  sha256 "59f72ea7cb5fce072523f3b6935853ff0bdbb9981b71d448f421a710cae0a844"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b64d64cb6e3918e60086ec424244cd419670bc7eab62ce0c153792b08212c1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b64d64cb6e3918e60086ec424244cd419670bc7eab62ce0c153792b08212c1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b64d64cb6e3918e60086ec424244cd419670bc7eab62ce0c153792b08212c1b"
    sha256 cellar: :any_skip_relocation, ventura:        "e1aeb2fcecc4b43d5f5d2b87e7331f6e85d31375a66693e1f8025300f2f5e365"
    sha256 cellar: :any_skip_relocation, monterey:       "e1aeb2fcecc4b43d5f5d2b87e7331f6e85d31375a66693e1f8025300f2f5e365"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1aeb2fcecc4b43d5f5d2b87e7331f6e85d31375a66693e1f8025300f2f5e365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b64d64cb6e3918e60086ec424244cd419670bc7eab62ce0c153792b08212c1b"
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