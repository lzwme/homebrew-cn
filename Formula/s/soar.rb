class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://ghfast.top/https://github.com/pkgforge/soar/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "1d289ea0291dd9b1ccaf5a124aa66005c31fd4fb3d0952a6f0df4a2231371ed2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "2ea838b4d80fedff52271a5b32d511b6f42772b61c3b66c78131f35c7e0c958b"
    sha256 cellar: :any, x86_64_linux: "d418e150ff0efdd2d2d397ee4b621ec8bca801aba5651e902960cb05a60a8f47"
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