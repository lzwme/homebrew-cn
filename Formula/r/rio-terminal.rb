class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3bec7576331c2bafac7cbb74da2f371c0c14f172fa343c6def2a3af8f6bb5a13"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8056e8636408ddee196b5af62ee1cee7df8a04797e08777a94173e8da16ae112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d325bfe5cec842516fb812bca80d9843f7b13383075432dfda487b5970e38e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc26d65b6caad17db7121a78e99a4735da10c375acfb5ebf82c4b48bc1802753"
    sha256 cellar: :any_skip_relocation, sonoma:        "d614fae4f6dcbe45e8b586fbd74f0e436f21fb13ea796eda46b28bb5319629eb"
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