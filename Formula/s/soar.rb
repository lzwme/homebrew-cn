class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://ghfast.top/https://github.com/pkgforge/soar/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "3d5370d111be8855d14eade20b259a978b55cfae320f005c7c924b187a28816a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "8578461afb56ae017448209687fae9a5fa807d8923f99990589c110780b96e71"
    sha256 cellar: :any, x86_64_linux: "7671accfd9b2ed8d25f1c87adabc623011d529c4f0c8a992efbb62753b393e2d"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', shell_output("cat test.toml")
  end
end