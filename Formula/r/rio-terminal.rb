class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "87d82f4fe3c4530252df9a2102e694ed953bc171ebb3b2b00bbdc849f874b94d"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2f4394ab5c8588b535f14b71bb07482df05a2a61e5d67c69c053d915fa70a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e94d5caa39cbbb04783d71f6b1951d37bb4768b4844283f73555169b858a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "587a4801b8e95265722fd6d1d3f6ccf8a348be5636215918df2d2ee294b7d85e"
    sha256 cellar: :any_skip_relocation, sonoma:        "532118e70bf3926ce64e0de1803ce2807a7d0285a0cf7a15dbd8a12c4117694c"
    sha256 cellar: :any_skip_relocation, ventura:       "09a24e748c1d8ddadbb9e3e2d484176ee4b50e86043256eea5f83dc1e6965ac9"
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

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_match "enable-log-file = false", (testpath/"rio.toml").read
  end
end