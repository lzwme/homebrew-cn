class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "6fc453e9e4c21a6da46b461dc8d3bc50bcfcc2c39a7da5c3b9e7c7f18cb51dd6"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6166c1ef26fcd8178d793c20485ceedca8dc53fd75a9a85bc3f6e7efb0bb00e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f207d1aa12a50e827dd5361ca69b44e1354ce9f7fd5a0dc8abdbc91fa429013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc911cb933ccab1357f42d9f1002a7d62b12d5fffaa70458cccf80ce732c9ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d07ea198e32fe9e23077f870426cc31b8e03ddc8b14cfb3a65f29c8e7c4068ac"
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