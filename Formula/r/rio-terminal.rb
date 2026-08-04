class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://ghfast.top/https://github.com/raphamorim/rio/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "36652d80d9e150a3145af96a177b7cf9e4d65f3d797f038f0593b36a7978e5f8"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91ee9bb14ddb870231a3338830f2f3ed84af4ebad09cd47593f478abb2fda1c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42a9dba585007f1ca727dc1467919f37630bcd50147ed56a9b296170a8f38946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "519766aea981bddf3da79396934b79ddea36044942a8335e1e593b64ebff3fe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e8da87070fa3494d2610d00fe18cb104b33b318ba9215353a52d8a726bae033"
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