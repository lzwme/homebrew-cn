class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "3b6f8d89752b4d9f83cbc012c7137432b3c8016855374c7bf178c357ecaeea72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c73d574aa50e9333bfb251dc3e0711b7606817ae7755b14fd60d5560ce033e77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2483f2b1a514299907698b65d86e7d0dce646991e0a4b6bde66c5d80b75f653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1289bb170b5d9e9353544f7d33abe43e6f9f469ed3e6000ed5acfce54243e30c"
    sha256 cellar: :any,                 arm64_linux:       "917827c7cfa807b052af1bc90b498f1b699cdb788860863a496dd1b780383c7f"
    sha256 cellar: :any,                 x86_64_linux:      "0489099fee84050fbeba680c16c579c202b3ebcc24ec685ab53e42c0add8d1e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end