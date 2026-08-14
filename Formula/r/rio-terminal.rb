class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.24.tar.gz"
  sha256 "f8412e719fda7c5d95bcd00aad38d54596998900ad98077dcfc5c1b7c3c9a496"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db0069afa27f9181494fe1701f1f49c1b1f5e0f39f0c7937256aac83fb3c8fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3da9b30a98e23a77e6ed667e3d826b7dfaec181c3c39ac5defddfbc2f3d2573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac058f8784a8b0c08b0449c5495ab95459e3ef49ec307412c5fcd2586a3cb40"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32540c6e7fd5fc6206f2a131d628877d69deba9bc87da2cea0a0be9f726c19c"
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