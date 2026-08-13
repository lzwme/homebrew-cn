class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.23.tar.gz"
  sha256 "796c4fe75003e36c791dd73182c925c66da0c5fca4721fb7c0daaa961617125f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e4d51043e068d02150335d1810ddaeb4dd829dc4e568b1d2d480851f2c3aa94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a466574836bac21b9bad020752b8efd31cea2eed832849eacd38d9bc3fba24a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163701946d3e476eaee71a79bb57ea1d995d46f08ac11ba2250827228ae10bfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0238e8f10411df4d1aa1da5c6b93ed3cbdd5baf79d5c23e1a0dc34295cddafd"
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