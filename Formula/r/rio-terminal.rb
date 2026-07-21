class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "508c89e2b2485ecb91c05cada88ab0d336440bba649c2f8e458def1db94d6fc0"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ec5a5d641d72923c926d53dc92f272afd349d1d56c6c710293ff6db8847872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2abe952a081259f3027aadecccbd4fb23282ae6ecbc3067c770b9d0d996041bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "787dfdc7c2fbb0c3c12a205982edcfaadae266a06e6dcecbb3593710e279a27a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0b8ff83aeca82650b8e1583a220445bd6fe0f3b3dd819fc59225562e37af5f"
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