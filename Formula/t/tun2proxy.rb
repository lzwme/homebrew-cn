class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "4b99f7108f13eb4685777a76b9ecae2173f9786b20be7e740f1cc6400d812bee"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66d1b6294adb34a35878b8b66aa3ea73ca11796f446efdd343a0509206d2c0c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb94b60f18e7b5f19bb4e3009c0041c69e4db6f498566ac7b4d5962015dc752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0726135dd6a62c239ac311e63d11f9467a77fa2dd1078e7ccfcef84a9e6995c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8142df97f5a4944fb487f2d901be9c05de1770217961709ae29fafdcb610197d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2905d18a2b66e5061596fa529ccfdf6e3bca2f0e6ae09329604ca565f2d9174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c2a4a031876bc70634e7d4e1a6b7efc6d3922dbfd7608bd446ae716652c3e7f"
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