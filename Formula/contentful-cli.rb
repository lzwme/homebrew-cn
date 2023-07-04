require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.25.tgz"
  sha256 "eabbe2e4eefa17be1efb40dd41a4603cbb8cec8df9abdc3f4cf1010bd183326f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8feb08e7ad1542d0dae71a3342c745c45d095ef037e19a39a25f1bf243292b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8feb08e7ad1542d0dae71a3342c745c45d095ef037e19a39a25f1bf243292b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a8feb08e7ad1542d0dae71a3342c745c45d095ef037e19a39a25f1bf243292b"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9f6d54f12658ac52cd1f0597746eac5ccc41c92fc5c687a34d8dbdcc373644"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9f6d54f12658ac52cd1f0597746eac5ccc41c92fc5c687a34d8dbdcc373644"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e9f6d54f12658ac52cd1f0597746eac5ccc41c92fc5c687a34d8dbdcc373644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a8feb08e7ad1542d0dae71a3342c745c45d095ef037e19a39a25f1bf243292b"
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