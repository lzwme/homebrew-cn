class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://ghproxy.com/https://github.com/bensadeh/circumflex/archive/refs/tags/2.8.1.tar.gz"
  sha256 "17352cff203e38caa1ea3fb7b181d61a74bee8d9e2882c93b865c7163cbb2a77"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb9554a65beee272bf51e38745fd8e6ecf69634925b8f7831737d9571446cc27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c298264ff973b2580aa36f8c078cd07c54374f78af3232e338aa430e952ded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4352b4ab66aeae09bcce472b5450b24d175974699ad7c6c30b2cb96166442e0b"
    sha256 cellar: :any_skip_relocation, ventura:        "9c53e5cc6011093dd6c7a230f8cf147d692c4cf2c0c635681b8cb3e0a7b80b39"
    sha256 cellar: :any_skip_relocation, monterey:       "58e1a2d6753eb15ca2495283211c19bb798252cd2e26a13f848734a46f66fd6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2580999f143674642972bae20713bbe01397c30ebc4e1b6e27a20c2b872a6456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5ac1c343322ffd0736367ad1a25b2d0e1ed6b6e609fa788584ac264810cc1b"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end