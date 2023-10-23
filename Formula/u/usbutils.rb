class Usbutils < Formula
  desc "List detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "http://www.linux-usb.org/"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-016.tar.gz"
  sha256 "a039479b88979d8e6dafa5a82d91eb5183b087104204a87d0e7ae6a26257f0e5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/"
    regex(/href=.*?usbutils[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22b2748584a3a2dadb98f2358bf3e8c626e86116d0f86d8f31cabde5a9510ef7"
    sha256 cellar: :any,                 arm64_ventura:  "3a764eca8ec97a20e574155971ca36d605e147895cfe662e928b9fdc9e1d3ea4"
    sha256 cellar: :any,                 arm64_monterey: "e666369f0a077167aaefc89d35cae73155de75a99a1283a2b20619a598ab27e7"
    sha256 cellar: :any,                 sonoma:         "9339cb51844c2fca1291cd46c004ba63412be085c97b1447c1c32da6e35eb55f"
    sha256 cellar: :any,                 ventura:        "3615052e1133e70b936e9976abcd205409cc1d84983936ab8e41d79fd114b2ca"
    sha256 cellar: :any,                 monterey:       "08689120babf873589ba31a10b5dbe78544401601b15d0370271125d0af155a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47e38802224bad18abd534a2d48dc84092382f4b60084b221f15ff53adbeab2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  conflicts_with "lsusb", because: "both provide an `lsusb` binary"

  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/9ef20debdfb9995fec347e401f2b5eb7b6c76f07/usbutils/portable.patch"
    sha256 "645cf353cd2ce0c0ee4f8c4129c3b39488c23d0ab13f4cfdef07f55f23381933"
  end

  def install
    system "autoreconf", "--verbose", "--force", "--install"
    system "./configure", "--disable-debug",
                          *std_configure_args

    system "make", "install"
  end

  def caveats
    <<~EOS
      usbhid-dump requires either proper code signing with com.apple.vm.device-access
      entitlement or root privilege
    EOS
  end

  test do
    assert_empty shell_output("#{bin}/lsusb -d ffff:ffff", 1)
  end
end