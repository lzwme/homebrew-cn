class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "66e74605c5942bb400969b10adaec124934d23e0b67d662eded16248ae0352a6"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c27afc36f8a919b00175106facec46b9f8cd4f3b244e022bb59f58100b391a58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01c6365b15e09f26a3058df552c9a7d451162396b1d62af00d49a92456565eb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fca5cb14888d145299aec54f5162c506635f96eeea96cc9595aaa129b0031b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5ab1cdd98c36cfd61ee6391b15e2cdd4726f91e6c49328408133b974422dd0"
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