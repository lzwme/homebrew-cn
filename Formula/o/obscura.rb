class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://ghfast.top/https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e8cfbad9025bd79d4f22da55e2c0f9111b8a082b821805f258c6be2594f25111"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7388878a423b024fa93437a1c12277d7b90b3a865aca3c20c2b4edcdfe34231"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1417a897e7c74e10b2fa70b6d4185c720d053fc0ec6b30e13d62ffcff4277cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1102fb7d353aae3bc53fb19806423964999a61c25b957917ae3563dc6c280e8"
    sha256 cellar: :any,                 arm64_linux:       "720ab48d9045c2ea5e04f4b28fd05f49349f6670ed4a000801bce1b7f1c8046f"
    sha256 cellar: :any,                 x86_64_linux:      "f0818345067d69c798022e9282c3d37a4d36207a5a2466c85ba4b4970be79bb4"
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