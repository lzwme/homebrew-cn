class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.17.tar.gz"
  sha256 "8aafccb9853dc3d380ad0b7ae6a310e6a730624cd6c20e1164ff7f5a28fd650a"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6adc1d72ad40e58175bda17c568c78a7ded9dfff7ba39d77612190458ee394a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e4964bfc55d06179ae07c02381d2c4f0da221a3bb244476db628fe48fbf34cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b2491772b19accfa4a48b8d505c054a5d2d4b8679b9cc60613ab3ce1261a3db"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0554fad3ef8bc3629337d98d170512609b2a29c2ca7642dd3e891e0e539e8ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e623fd082f0d25821ef4f5aba773514662ef0cf3d3c3dc553a17bc2f4401cc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ecd244efd92a56d513eabd10623176a77e2045b7643f0fcd76e0a63f261c8bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end