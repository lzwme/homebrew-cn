class Moproxy < Formula
  desc "Transparent TCP to SOCKSv5/HTTP proxy on Linux written in Rust"
  homepage "https://github.com/sorz/moproxy"
  url "https://ghfast.top/https://github.com/sorz/moproxy/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "ba73c23e62cc259a6212df5a8cee2e002596be9ede1f4c2c5918f3ec538fdbc9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"moproxy", "--help"
  end
end