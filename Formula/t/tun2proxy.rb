class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "b0e23f7a1bc502db2b25803bd9a2cc53529e2649bec3e4e461f133b2751e3261"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ea3df46f2f632ded6e198a5d6cef2879a731e4ac7e58e48cc6b00dedc9e7fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9519170110a53e8fd5f379950ee49873d4b7aec6fd59bc8cd2dfd71194e9abd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00bcdd57061093c3d7395e330f7fdfcbe4bd4bb4e038e8c6fc676c19ab94f69b"
    sha256 cellar: :any_skip_relocation, sonoma:        "727aa2e0754936f7444b32aa7d55988e8ecd97857d2410543146dfac5367ee88"
    sha256 cellar: :any_skip_relocation, ventura:       "2f1ac5c0c4e6f719cc476b4c505a3db4d0aa40bc7d9774e7be4f3a263587a651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b08e3ff0027e1cdbe3f76267bf7e03de71e1ad7dde0f11a7861c70b6126cc1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b86f1d841b6b0c38011bb18cd0f8116f1051b87459ab7c88ea6f1bd31ac061f"
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