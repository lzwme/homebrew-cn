class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "b4849138ea4be3d8ff5b5d79463a0bfc6085f8470b3566ab18368fa966901d68"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79bd3596bfca37e7f0b5888cf2e732b4e92a581b0b7441594656146ac9655975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fe68a57cba5dc6ae5ea0fa26a2e75aab101e3980a24cf75c43c817fa3fea26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "682005053f417af25358c49a3c6ea8e715cedfae184f8c688d27f682b982b29a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7863888702c4f5643027ebeca820357b5145118e5d39647beb3fec918e53cb40"
    sha256 cellar: :any_skip_relocation, ventura:       "bce89c75b6bf87bfb8ebfd9959e9213b544d34e0f6a816947b52f6e46007e5f3"
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