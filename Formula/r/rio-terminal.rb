class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.33.tar.gz"
  sha256 "0800dccb3d4971dd35a233ff1ffa6cdea8aaf76fd2b5cf45d3fe2cd0bb1987a4"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f906c4790f8271573ccfb00107a903a9e538aaa1763bfa93e9a8feb1fd5dddba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd65351ebf0d7926cf7f79663db51a7df701fa12f3fd09c9ab2da62912693240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19e0a176b82913fe9bd1a3a4d54dc73e1f8e44d513f6cb057f00d3eecb9c6f6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a7329ab07ed5f87b26871340e089ee89db734fecd3f57e6a095c3aa8e1df07"
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