class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://ghfast.top/https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "1ac2f5e2b5ac44b0c9ec21143a1ef4888ac9e655e3a97cc6a829cf29eda67e80"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9743a931334281381c0d09565e50bb3f0da96236221f97ee81d5f786a5bbb390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a168a015e300427d8585c0d426ff34436167722db614fba691e44ad06c0b1ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18140711cacd403f182f11bfe0edd45aa17e845725f49628b4559c5e7735cd11"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b09f5df7d85dbd82af9a78d20e4f5f4edea6a30e21052c36ca7c9b2bcd3e6de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b30f3673d1665e4175385ece741405c0718e8ee6923743d07a8188cf10aeadc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed6413f06ac86bcacdafaf00226d09a98127a94a5e86003f2b02e7db0db0d36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudflare-speed-cli --version")

    output = shell_output("#{bin}/cloudflare-speed-cli --json --skip-diagnostics " \
                          "--auto-save false --download-duration 1s --upload-duration 1s")
    assert_equal "https://speed.cloudflare.com", JSON.parse(output)["base_url"]
  end
end