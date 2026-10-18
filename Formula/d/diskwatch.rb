class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "ece3421dad97054318d3e511dd360cae019e26bbbf7d29b5214aafb8de6da9aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2d05a5d162f4245a01e7fb18b904d6fbdb152714019b6946b9c1ab94f0b2563"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "745c6a7caaf313d11bbaf7985e3eb69fedfeac967e0722484df515cec803796f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f0e77cf6bff716bf67b7dab10a11eebd9d7f49b4f36600270915feee674556e"
    sha256 cellar: :any,                 arm64_linux:       "f9eea2c40f7363c3bdfd16e52f880847a224e1004ac77b8db262c7cc8aef27b1"
    sha256 cellar: :any,                 x86_64_linux:      "a65b8caea91bd5f0cb6355c24b37d92e3b517289c223e710fbbba1fda1d30a84"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end