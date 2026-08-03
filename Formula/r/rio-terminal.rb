class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "3e67926c14f54e3f3359a6461a17cb3a58400cf57b491d2fda974d6821e47d51"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cf58185a2f12dbfce5ce308da08ea3ffbde5b07d04483cea902182e6ef4fd1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34ef6ae21ccd55ade6de024fb9f725658eb6fd33f6ccddb3f8897f5f0483c803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b02db2ae14ab20c4862c6b22528cbb866988461dbda841466c4935d6469d1e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cbb36090413d22ba46dc32d6a762ffcebbfc5081e9986e8c59236a8919655ff"
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