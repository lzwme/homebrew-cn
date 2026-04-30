class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "4b36a0daaa778a69a5b6f4d770814a757ffdec58aef9e6bcfd77d8d9a26a99ce"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72a173828e9a9783b02c94642217300f37ee5141635b850516bfede42fb34326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0950237f4405effa7764bfac573b45c9ec38afec008e3166323fe5f5a39c236e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5768d86dc292795593229a5f8a64484eb7ec3773e8429ce0d334098f5e621b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d70625eeca84874336f469364c1b3fd6a5fbeb7ab855a22c647eb449d1d749"
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