class Moproxy < Formula
  desc "Transparent TCP to SOCKSv5/HTTP proxy on Linux written in Rust"
  homepage "https://github.com/sorz/moproxy"
  url "https://ghproxy.com/https://github.com/sorz/moproxy/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "bf91d6b2bcd98fa799556f4e46c44948c6ab6eb1e8fb51e2c420b8e95a6c1b83"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/moproxy", "--help"
  end
end