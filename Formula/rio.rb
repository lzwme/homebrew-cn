class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghproxy.com/https://github.com/raphamorim/rio/archive/refs/tags/v0.0.9.tar.gz"
  sha256 "ff9388460fbaea1f63fc47b478ccdd1a09941e7a96cea6c70ffa24b8d88f1e8d"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c165f99f3827f0a06c623dd1d677b7736140e260bb97287f3000bdb789684f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e514862b4425436f9a99f57c78524fca512d5438acac643529667659ac189330"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46415b8cfde957e954b8e45f65cbd678eb33849df78f743331c14b847b997217"
    sha256 cellar: :any_skip_relocation, ventura:        "ccf7474282f05a5bc15cad18f5e47acebd5013ea979ecbc3a65cec1650e67387"
    sha256 cellar: :any_skip_relocation, monterey:       "7598be17a155389567687525d45e4fe71c7ae642e5d97e0cbafe542c66fc959e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce47c5fe46cabf378d41ba737925abb075b63b07b9266d2f8d6b9ab9d38221b"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end