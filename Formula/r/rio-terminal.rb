class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "9e885a778615b1669a2f7f0d54eeb0ee5e4d4f4d0754f142bfd6b1ee0ebbce35"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d447ab3b44d3200d1891b5217efa590c59a734b389e51ed8e9589ccbb3638209"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15441e21f170e8f3c44f9fe4f19aeb4fc88012f693307122e2f1dc227a4d960c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cabad22c4e5483b5cefa6a2bdf4ea8dd2d5041ede086d1e5010547c5a5c0b55"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5ce1eaf493299a543295455e5ab6b1303b7018edbf185bc7515264fd33f520"
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