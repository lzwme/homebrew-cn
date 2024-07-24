require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.440.0.tgz"
  sha256 "e98dcafdfa2aa6cdc4ad161677a6ee466eb87b2cd038beb856c5fed3bf001546"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69b62c2a1ffc50870fa7227951c44e4c11e67c120473bb641018ce9824c953e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2368aa37883a93fac5854cba87c60d5bf0cec20ca9b63a2b6c40f52ad42e40a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8a2b2533b6d96b75f1fac3d387d914890f4f13f6d89a132ba7b76366e4f6c19"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eb8f2dbbe90421e5514e51daec5674f89025053efff5ef612220aec29c53d63"
    sha256 cellar: :any_skip_relocation, ventura:        "2926862680c34624618688a92fab3e68e2b72c528678bf87fe8fcee8a2bf54bb"
    sha256 cellar: :any_skip_relocation, monterey:       "d2b1b3902a1a6cb85435e641b6e3165932626f3f60a250e7ac74c24c6628a3ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39029c4268bd0f9334bf770518cbe3098727c12f351e9a1bc5a762fed9f9ed7"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end