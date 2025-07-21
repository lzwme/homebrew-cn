class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://ghfast.top/https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "fbeb2e4c941e7fc46ceaafb47422a57b55aeef703de1d08a7d71292f6c127240"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b24b4307e634735e79ebfcc44f6e0e42c3a7201a66bb2bf47b1aa8587118bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2bf3c5d42f598bab16b7e3904ebc514857203552cf52bb0cdd2a1d2f735fccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "775768bc7470aaa578e35f98d6c0202c2748e039ab8fa2899597b31425e9a297"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f7d8f2803ca24edd26e115d26ddf994136094a93d20715a2b7683659b915999"
    sha256 cellar: :any_skip_relocation, ventura:       "839c5f4d82018a0e3237bf3c47be5dd35e1356d56e9c8dd94d9214c390e3f16a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40f8c868c5f1c910db7ecd054fbe57dcb54d1a42731ac97d81ced79bf0db94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fcb4c18973c342d417850b79eb952d8e3cf2058b00f4b316f99378196dca4c0"
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