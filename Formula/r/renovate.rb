class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.55.0.tgz"
  sha256 "a888142970296c75ad0fd2c469b536d69d8df4bdec3a685975163e049237af3f"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8a3611540e34057028e475afdfb6acaf43b1d0e48817ea9a70a28abf80ec31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f03ce069fc888c3e552db70982fb240a14a55452e19bfc70baecac04a285cfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9ccc6d8803f32dfeec3d579d4ceae2f13fe1a81e9a17d9c70cfec58168f7f38"
    sha256 cellar: :any_skip_relocation, sonoma:        "323ec5992b8ae2789eaaa21eb70c247583379cb8f29d0f239ef8f1ff8df81055"
    sha256 cellar: :any_skip_relocation, ventura:       "37a6504e188eba621387440423043fee4793bc48f672a7d37f21f1948e53f352"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c539f4c059a18ce64643f7cf578a35985639a75c7b7da67af45d5658c8ee6d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e3f66c124bc9f4002de167edc562250d228d062f02ce6362de5bf9b0a719ad"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end