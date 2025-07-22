class Netmask < Formula
  desc "IP address netmask generation utility"
  homepage "https://github.com/tlby/netmask/blob/master/README"
  url "https://ghfast.top/https://github.com/tlby/netmask/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "7d4adef47e5c9aba919d099640f1f08aa88f8de9538c43a13233c1af44644be2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91c23489b50c0d3d09713fa26c18dac951cf63ffc39e2680326f75ad67acedfa"
    sha256 cellar: :any,                 arm64_sonoma:  "3a42ddaeff18b5d164f687705de1b94401df54fe57c47d4efd8cb6ae1ad46839"
    sha256 cellar: :any,                 arm64_ventura: "52397f337418a77f198f1659c3bc361aa98be671dc7b300b66bb425f3d4f2005"
    sha256 cellar: :any,                 sonoma:        "f4c9960ac92cdb675aa5a39a8c8d706717ea2d56d5381eeeaa7244ac7866bf55"
    sha256 cellar: :any,                 ventura:       "be9ea01dcc993aadb6cb8e33f559049b0bcf326f8f9b47fa7aa47682dd70c380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7217c2f0dc2b48687b2a6f910c52d3e2e50407480709a79ef1a614f99afc6dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561d2d15b6049381f15e8d4d98d0a6f6c02a2fd270a23ecefe87b7fd61c9d20f"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "check"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./bootstrap"
    system "./configure"
    system "make"
    bin.install "netmask"
  end

  test do
    assert_equal "100.64.0.0/10", shell_output("#{bin}/netmask -c 100.64.0.0:100.127.255.255").strip
  end
end