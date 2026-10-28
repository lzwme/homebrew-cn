class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://ghfast.top/https://github.com/pkgforge/soar/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6544821a1cea17397cff1db5cbde5ff45bfd92770c18a22ce2d7421e4aec1684"
  license "MIT"
  head "https://github.com/pkgforge/soar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "0f39b801425934672aa2a1cb6720bec1099cb7eadeaa7e7c591f2c8c75209bda"
    sha256 cellar: :any, x86_64_linux: "715f25b152ff749173d0b7793b19ca72520709bc5508326e0fee28b6c408dd26"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', (testpath/"test.toml").read
  end
end