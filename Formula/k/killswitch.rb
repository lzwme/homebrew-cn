class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://killswitch.network"
  url "https://ghfast.top/https://github.com/vpn-kill-switch/killswitch/archive/refs/tags/0.8.0.tar.gz"
  sha256 "99f33cdbb73ba6b2f783c567254f97e12351ba883db61f0f48523c97a9107a46"
  license "BSD-3-Clause"
  head "https://github.com/vpn-kill-switch/killswitch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a1f8910f36c6144ab78183ea8bc519dc3ec5e0ed00faffe5e6eb74c375e4c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ddae10928e2d9cde999613705ee3d2ab807035cb125b5f174b0f87117e1aeb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e2a297f1b904bd4115c86e655ff8d153d2a0afd4f5d3be3441a8c6a7429c555"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f0f6a769dd08ae5a45253cbbda6824813c5d585e2cb43d230b3925eb65ffc2d"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/killswitch 2>&1")
    assert_match "No VPN interface found", output
  end
end