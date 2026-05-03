class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "1c4880513722028d3baa76e76b0c45570486d8b3deb168bf796780dc1eb117b5"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e29af3d7dce648b4bbd39e84acda31ace4289f34051d7c4204b6bff83420387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de54fedf3d5b858b06257c3660c7c2526f78ab95cc91f7818921e2601113344c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "040f22e7575025705f3ced6305b030d3a8749b0db05f0d67ae8a8fa0792b0dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "200641e13c9b69ded2d58c14a5916e9e0d7bb1bea027ad9d4e71f46549bfbd26"
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