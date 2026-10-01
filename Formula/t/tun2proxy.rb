class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "ab038ee45b727d121e544c1bd23ba4426a1b747b6ab279b43028e8733e3920ae"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce6de24475e2e16b2ca9d34b9fc26675d7aadcc431a8d064a0fc5bff209299b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c80043423bb8b6d572386cd0aa70c9c1038ff8dd48f8f03eacca8bf7f5fc1a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c33f981ce590a07cb9fc6c4f3427424787bc2e907abac2c3fbd54f321f55b59d"
    sha256 cellar: :any,                 arm64_linux:       "69bab45cef45eba991fa569de4c0cdda2487a6969d4e52d57ad6e2ba985d17b0"
    sha256 cellar: :any,                 x86_64_linux:      "54a3e44fc8237359487187b0882f52337859c61f4c24a38375fdce1c0de51a7e"
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