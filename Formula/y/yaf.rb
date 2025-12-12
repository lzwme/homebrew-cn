class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.18.2.tar.gz"
  sha256 "b2324e6c5468e4748e59d9f33312decc8e72cc9ee51e927cd7e77b3d3584d909"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2461d16db50027d858d889e9ca08476103d2e05599b222635c8fc0957d730c5"
    sha256 cellar: :any,                 arm64_sequoia: "535f168208c61a4357fd2c19d17762696b88bcf2239e088a618f87852349fbb5"
    sha256 cellar: :any,                 arm64_sonoma:  "cfa7304be5e50eec278e09863f79c71669df96c3d6d44967720a4b2f47785352"
    sha256 cellar: :any,                 sonoma:        "a5af33750b3d302b0230c276a16655e3a8469355ecc4babd36cecf45511d936c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a127992c1701c3908a38d1ffea02c891af3f2718745898ab6ec5dad2abf98426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c4f60c383485adc953ed5bf7811e5590bb56948161908d84c53f3588417176"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"))
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end