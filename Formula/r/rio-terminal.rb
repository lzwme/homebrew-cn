class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "11e84859757d9872f0c39be8cc9c751d2b8329e222cc5a49dacab43e94627b6d"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4e65cd65a9ee4ff1bf91822765652cacc3b22dd759601bbfe8cc023db3e6a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60323cc4b5a098c47687307218617fb4a782d3f26db464110a0eb888841a3e9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07829e3c276e41374009a5fa9cc9c11370cfeae02bf15c46ff51e92bfde14bf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b499d254cf37928dffa20c8942c5eec4342a0d2288d41b71311eaa3654668290"
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