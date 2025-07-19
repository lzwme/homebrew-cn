class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "a303e62e9b45b5a350fe7ff162dd6b2b2c3138b28a69c81fe93ea13b8df1e0dd"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7796e300d04d105a6414fde308e62e097dce59354c6ab53b4ec5b6ca2478f278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "110d578dc5a521ec0f3aeb1c25dc966ae7764fef03d13d2f35a881431cc54b03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af62b787a4a892b47ff7506297ed9a0c850a0cd24b387c575c5aabc8fa08b296"
    sha256 cellar: :any_skip_relocation, sonoma:        "993d2823a43154966c8d28b684dd2ccda21c95d84f93dbebe795711b07179a4d"
    sha256 cellar: :any_skip_relocation, ventura:       "44a34e6348167df9932581cf85acce0dc47714b9d3aa2bc49e5c8558b42b9ef8"
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