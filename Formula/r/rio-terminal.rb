class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "2fc5e4defdeb9beba257260a2dfdaa29b518dfc1a87de2145e94d57d309da27e"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cac60a4657ac348f4bcf76a91164598e26d700b128b12a8344df9d8aa0ec7b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "815697df707d17bbc79df542bccbc986b159e132b3b39c16bc5c25b092f62362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aceb691d9e8a1ec5b965ebe28986ac37823ad1f4d018a897c1c9e91898ed4874"
    sha256 cellar: :any_skip_relocation, sonoma:        "88a8ba301f9033ae4857d05538c124abcb8e19432062b7ff7a41123bc207a7b8"
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