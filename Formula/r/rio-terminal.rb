class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.27.tar.gz"
  sha256 "860cb019a4f6a87bffb786ac2408f51f7c7f09551be234355fb3fd4feeac5331"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc3e184e29e3031cf8da4713a02544c2ceab92173ac02451466e05c0029372e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88bc5884c178ebf46b988a538cf2ea3bfdae63a7dca6ec33adc7922e540bbc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bacf20df6f54d8bcedf1599cbd63fd407a5911f31627b7b2f89de2e38f898a2e"
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