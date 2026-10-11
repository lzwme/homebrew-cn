class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7c03a0373695ca4b07591c46ef5c1f8b5ce4d9e4fed8c8817656b4989dc7c540"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e18f2df490b9631d90c2f29091595c7d0ad37fc1c4979d26cb3c61f00ed37c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa3071ba0509a090a1a6e8377191490bd650c93348ce351c6b794ca5fd27b705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb7b267389430c3b97868d852496eeb223a236d2f26728d33ded03ae0a48e87c"
    sha256 cellar: :any,                 arm64_linux:       "7b41c3edb91af85a3fc90ff902bea21cb75e15507a8a1dba56314a35d2143852"
    sha256 cellar: :any,                 x86_64_linux:      "c9ccf7ef140d2e7353d1d68eb7ecce430f0182454f0db3762e31cc4c078cfa2c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end