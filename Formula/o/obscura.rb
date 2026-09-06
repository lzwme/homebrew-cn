class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://ghfast.top/https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "5fc644e4925574975ed4f7d4e6b91c5e0345461983d863dda64cbf4011e1c0f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de09e12f136a9eece2b09300911fd25ee6f55018f8cf35b7a7057acc255f2c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6382f83ddc46f029ffbb59ea7c27a213bcde889b9c5f6478073e915ffc872c81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be1ebad87f794cd7e740c36c40eff268ad4cfb7f9a70997c6182029d454e0f8a"
    sha256 cellar: :any,                 arm64_linux:   "6ee910b91138a51972496f2162a93af339416f265831f0ffae252554238f3e14"
    sha256 cellar: :any,                 x86_64_linux:  "89cd1848508294bc17653e777eb0693d08f1367a036a519c37719a3a41bb8f0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/obscura-cli")
  end

  test do
    output = shell_output(
      "#{bin}/obscura fetch 'data:text/html,<title>Homebrew Test</title>' --eval 'document.title'",
    )
    assert_equal "Homebrew Test\n", output

    # obscura blocks fetches to loopback/private addresses by default (SSRF protection)
    blocked = shell_output("#{bin}/obscura fetch http://127.0.0.1:1/ 2>&1", 1)
    assert_match "private/internal IP address", blocked
  end
end