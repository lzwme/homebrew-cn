class Obscura < Formula
  desc "Headless browser for AI agents and web scraping"
  homepage "https://obscura.sh"
  url "https://ghfast.top/https://github.com/h4ckf0r0day/obscura/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "af287fa7658270a68ad6f1220197eb55035614a91b14295117da78e55494958a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e6265bdc923ade5310d0c0cdf0e47cc7f0887559d2816aef7d5a82c3f12ca73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2d0978cde32fbf83590312e8316d767f2c5cd4b486a6616eb03a4734c758280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5579abb9a0269a21bce70edd61c3534dad61c6d89b4c62cdb7fbeae71b48fa67"
    sha256 cellar: :any,                 arm64_linux:       "0c62b7720beb99ed061a9711b1a8c3e77cca6448fcf78b5c40bb8fc168dcf880"
    sha256 cellar: :any,                 x86_64_linux:      "58e5d625a91e995dae52d7a24b0922bbdb6942f983869cc6df0974b3915f4e0a"
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