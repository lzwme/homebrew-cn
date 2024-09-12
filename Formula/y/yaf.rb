class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.16.0.tar.gz"
  sha256 "b8950b232ddb830e9a9e2730b77fef703c0528894cf2102ab8b787daa4d50c9b"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9d6f1a988ee2c576f61ee411ec0b6bcba99bb483aa5c9675c91725f21f5baee0"
    sha256 cellar: :any,                 arm64_sonoma:   "99b3ae3a27fb74180e398a84278456d40fc81293642d5a71d249b84d45340a05"
    sha256 cellar: :any,                 arm64_ventura:  "609715f03a9d6cd50ff0533a3d90c2bb20eb88f0ae7dc0cd04b703ca05b93c10"
    sha256 cellar: :any,                 arm64_monterey: "e62141f902e03d46a6b705804eb496b694d1fb0087077383b01476d84e439eb7"
    sha256 cellar: :any,                 sonoma:         "00b7982890a35868fd73a9843a813ff1dd3fd39c65f15f1fb49ad76482cae9e1"
    sha256 cellar: :any,                 ventura:        "97fe023afc62198292f548e3c409cc683f016a3521d953d074493642105ec7f7"
    sha256 cellar: :any,                 monterey:       "026337e66c2722cfb01ae5b9a6709f2dc2fef4c63f5c5a4df0e6cbb18e2141ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d134b052c4effa8b7a492af85d3531de1f2081fd832fad0b0b0cf9a76dfb1523"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = `#{bin}/yaf --in #{input} | #{bin}/yafscii`
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end