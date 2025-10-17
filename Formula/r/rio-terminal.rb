class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.32.tar.gz"
  sha256 "9bf78262811f07547a229922b3683c05fb586335baebaf2c9368348905c98405"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c2cda985174a8717a44c87af749dd549396c7b0d75927835ae9c19e1862ccd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2284cd9b031b865ca911661b9e4fd26c5d201e755204fa6369dfb4d01f2eda6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4922a7ac8e2f440fb4ba529934995d767cc0f9845db91dab5887209891d7622"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b2a8c334302b8853283d24a29552a453efd7a2b7474004690c7462ad06490ca"
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