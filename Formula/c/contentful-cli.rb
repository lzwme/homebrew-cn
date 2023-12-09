require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.25.tgz"
  sha256 "5132257f1b2ac7385759bf2124aaec32b39689b2394cf1de5b13dd4c5c6deefd"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc6f828d9cda55c40910840a0f31b94b8d2a199a27276cb8b01a97e99e109920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6f828d9cda55c40910840a0f31b94b8d2a199a27276cb8b01a97e99e109920"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6f828d9cda55c40910840a0f31b94b8d2a199a27276cb8b01a97e99e109920"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4438bc1907328b5ec963353e5fa00d044c77b8495b5cbbc07434aa4d5a17341"
    sha256 cellar: :any_skip_relocation, ventura:        "c4438bc1907328b5ec963353e5fa00d044c77b8495b5cbbc07434aa4d5a17341"
    sha256 cellar: :any_skip_relocation, monterey:       "c4438bc1907328b5ec963353e5fa00d044c77b8495b5cbbc07434aa4d5a17341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6f828d9cda55c40910840a0f31b94b8d2a199a27276cb8b01a97e99e109920"
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