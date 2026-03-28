class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.18.3.tar.gz"
  sha256 "4cee46b11371fc5b7b76044c7efadb1e30043e699eb0d8d1aa4f1ca6436e8cdd"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbdfcc645e3d97d078b53318943a5e44e86b6d2e3456180254057b16b577830e"
    sha256 cellar: :any,                 arm64_sequoia: "55475eea5c3d1e4a10c92fa824a2a57e8caaf884af0b1717391d8cfada89af61"
    sha256 cellar: :any,                 arm64_sonoma:  "af7898289f5b90c1a57294de12bc58fca05dab477084388fee266bce5abfb496"
    sha256 cellar: :any,                 sonoma:        "bd00807ff0368600337f5ef1a940928c828ffa39912a9281534d9eb034094629"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9205bfd89e5f641d0d373e5a0efd86422a77a43319e10bd2bcbac84ea58b2fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f861e973c78e50d22b0eb7153af58bab716a480eaedc37b866d39734d5f7b64"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"), 0)
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end