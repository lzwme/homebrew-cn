class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "d5d64702763103744f1ce7419c8773119678a305887514908ae38092888c0ad2"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1858a7c40181c9f03281fbe0b8f4a419183ec7cdd29fcca58725b14c01f4e41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8be6dc2879db9c5344af6dbeba0d33f1f2c63052ab9ae5a50e00b30d3df927e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25ab6bd752c175ec214014a3aaaa81c0260147af0323a223b39c62136d6e3fdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f13649b05212181ab2cf9b8a236f7d9fc9a24e672bcbefe82b7d22be3a72e51"
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