class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.2.35.tar.gz"
  sha256 "118e169e4a328544a3958da70ae6a8a804edb63294834312ac33faac6130d40f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d42fc71450727de17eae620ec318dbb355386c99852eff8eb9839ef085f324b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7515922e369f58e7eabafea3965dd7939d3ecc410df455f9eaa00f7ed9ad9d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d7f60aa68edaccc29edd9716be3fbb87829b82138fc4f38060febcc90b044d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b3b82c3ca623eb80a5614612cdd37f632aeae6b92dd5dcff4eef9f893cb1ba7"
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