class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.14.tar.gz"
  sha256 "3e0571b193d345e491e8e34882199def7b6cb2fbf55937cd3221933ecaf30be1"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "612971cf80132350354f34676175672f16bf7f1fd817ced364584877f15f6cdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc3c6e16e38b23ce887ef14a10659501cad6ebb849b9660a0fd9077cf3c4fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1bbf49bb80fecd38bb236204c0eebec37ed043f4309c97c494c77bc4b414b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "560f7ca7d0289be2d966c60dfac7f12124898886a821e835a14ea55802b213be"
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
    assert_path_exists testpath/"rio.toml"
  end
end