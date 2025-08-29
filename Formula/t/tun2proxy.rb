class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "905cf188791e6f6298da63488be5d71e4f47166c0886fb9bb34cf784255a84e0"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60462ed5bfe2eb89f640e461ae501b3b7addf69d012b66507da9629d249880ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fafac20b6f526ae82598e1f44357ba1d20b617a2a861607baf78539015958a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4de02e36bda610ca89ad45bbc2b22d136c28e487900ea0a0e41c2a25316e126"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fec02a7f782d698b8c89d4425448b7cf53fcbc7dd32b8b137494398c82fe501"
    sha256 cellar: :any_skip_relocation, ventura:       "95582381fa284e75bc611056593b75ffe8c17c23f1ae56076b2030c2d8e18e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5975ccffd248ed519a828b7f9c418a0687211928d8b1c7aec28eb6159aaf3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cbace68d9229f5b823968e941fc776394c6437da34df0298d41689f716a6d94"
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