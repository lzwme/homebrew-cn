class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "e4a138e76a0256d60f577b9ba42a765c09932dd9c8289a8cbfb73a867a35434e"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6eba2b6af4e16a78dfc86c421a2777a3663f05ac9008fab15c6d4b294ad94cca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d5b8dbf91ff17d117f254498398020fe975551d6d88c5d078202dd4c85768b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba3daa1edf9d2e90fe88a29bb773cfed9758f1d9ff8527aad9771b36ab8b71d8"
    sha256 cellar: :any,                 arm64_linux:       "9bcbfecba1a54c7b35e1258934ae40f640eef74d55ab5c40cd8fda4e7fdcf87d"
    sha256 cellar: :any,                 x86_64_linux:      "195c7ccd490e0891f25897df4297aecdd52e04bea17eef003a00b49437576348"
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