class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.21.tar.gz"
  sha256 "25232c6f21ce7ae791b0aaf8dd3ed2ad765ef7cb45258cb83f60c9df19388e7b"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc6f66c87500ad9abdd9010dcb631f34a5dc0d5780fb7cef0ef898e3c5bc2ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96cf43c4cc11e16fb18658bdd5e06b01e0b18e1d9b263d2f2de954485f89c21d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "649ac273f11b8b4a8fab072480c281b96db71f43539770a7f32aa7ec3118076d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a13ea0a24a8342c71323f292f2c0d07dac431e6598c84472e8b12a921ffc68b"
    sha256 cellar: :any_skip_relocation, ventura:       "a41c852160b8a6d6a3748eae3c47f356cf4e746b0837abde2ead5ab1732545ad"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_path_exists testpath/"testfile"
  end
end