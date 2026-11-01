class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "6264bdd7fbede43fb74fa1f0c3eb19d3f5b5ba4628ba8efedaf3ba2d3eaae622"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11733ff9174654c2580116261c5524a4af1c79448f76a2c5f971c2bdc56c2b7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4edb3597f32ba25b14bfa6c44d0bdf0f118f3b9b6197f8966302c0fba8dea100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8505e0fc3465a2250fd418508a75f05696db72d7eddaf7e8d0c3f2cd35d1fb62"
    sha256 cellar: :any,                 arm64_linux:       "2e8467ba41834e45550ed93a8f760657185cff8eadb45a429ee2cb3b51c0eeca"
    sha256 cellar: :any,                 x86_64_linux:      "69b863ab9b16d9ce36b8b181448f9d315c3334a205a94b014a48d08fe9890cf4"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    # `Cargo.lock` is ignored
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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