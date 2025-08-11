class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.28.tar.gz"
  sha256 "cd0a72997a1dfb3d2d05b22a6cf6d22d512dfa8a2946f2fefcdcf6fbebbb485c"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44c8a066b5767db71d31db244714c941e35c53d3881cce545cfa48060c576e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cbd0da02679aa4dcac8580e2ed01ce7e0b81b6b860f9ca5db85b992a038ef35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04c26e312510092e7b093154eb86cdc444e8f5a44a6b6931362cf0496655ee07"
    sha256 cellar: :any_skip_relocation, sonoma:        "905cf0fd1d8118a043ebfb5ed054dd755dd955c03c432bf9ae36366aa416853b"
    sha256 cellar: :any_skip_relocation, ventura:       "0c5a961d554701a67dc43028aa561b2e6b3decbdd82b31060a917bf7b02e2e35"
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