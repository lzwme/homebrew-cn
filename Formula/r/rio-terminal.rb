class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "1f5df2e3513c62f8fd0009ec8037afd202498512fdc49d03e4ff7c4dca74250e"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4722281de30efd3341f37b6153c4b01cc785549ca0e68a5ca01428ecd63faa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019bbc7fd21a5863608bbde71d0c878e26665020475074454b7597c66bbbb849"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af9393d546235120522cdbdcf9375e1b838646dcccd0fdf01568933b18c977fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f45339eda498e0575a7b7c1d82c451459ad65ce8de68a7ac026ea2bf3474902b"
    sha256 cellar: :any_skip_relocation, ventura:       "ce48ff6e345686f2f81d7c46447c0b5023dabb3146dca86f16bcc63e056f5ac3"
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