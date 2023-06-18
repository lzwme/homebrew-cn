class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://ghproxy.com/https://github.com/bensadeh/circumflex/archive/refs/tags/3.1.1.tar.gz"
  sha256 "2c2f1d44103fb51875aed86070f1cb007a19d1dae2b16b7820539c85db0c3c8a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c370d71cbbea8079175bd01eeba43babba02b3273398a1c34d5f61631b3633f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c370d71cbbea8079175bd01eeba43babba02b3273398a1c34d5f61631b3633f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c370d71cbbea8079175bd01eeba43babba02b3273398a1c34d5f61631b3633f"
    sha256 cellar: :any_skip_relocation, ventura:        "516ae714ce36a2f03c2ee6f5dd14508092d1e14109460c36b27b1249026924a0"
    sha256 cellar: :any_skip_relocation, monterey:       "516ae714ce36a2f03c2ee6f5dd14508092d1e14109460c36b27b1249026924a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "516ae714ce36a2f03c2ee6f5dd14508092d1e14109460c36b27b1249026924a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1867e4b7bdb0642e09bbcfa62d4d5552a5313d07963e51e2ca912bd9dbdf959b"
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