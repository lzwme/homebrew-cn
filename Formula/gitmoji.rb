require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.2.3.tgz"
  sha256 "afd81a59d56a051e4276089233d9d1a6c3b11b805cbcc541e0f02b1c942968c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb137016430ac6761cde4a6faf1643490cc08bb7adb4e491727a6e1f3b8e8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb137016430ac6761cde4a6faf1643490cc08bb7adb4e491727a6e1f3b8e8f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcb137016430ac6761cde4a6faf1643490cc08bb7adb4e491727a6e1f3b8e8f2"
    sha256 cellar: :any_skip_relocation, ventura:        "da58a6161c3721dfe6566d7f357ff8eb65c3bd3fb0331d192eb9c16f798a2db0"
    sha256 cellar: :any_skip_relocation, monterey:       "da58a6161c3721dfe6566d7f357ff8eb65c3bd3fb0331d192eb9c16f798a2db0"
    sha256 cellar: :any_skip_relocation, big_sur:        "da58a6161c3721dfe6566d7f357ff8eb65c3bd3fb0331d192eb9c16f798a2db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb137016430ac6761cde4a6faf1643490cc08bb7adb4e491727a6e1f3b8e8f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end