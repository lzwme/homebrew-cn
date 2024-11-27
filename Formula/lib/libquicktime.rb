class Libquicktime < Formula
  desc "Library for reading and writing quicktime files"
  homepage "https:libquicktime.sourceforge.net"
  url "https:downloads.sourceforge.netprojectlibquicktimelibquicktime1.2.4libquicktime-1.2.4.tar.gz"
  sha256 "1c53359c33b31347b4d7b00d3611463fe5e942cae3ec0fefe0d2fd413fd47368"
  license "LGPL-2.1-or-later"
  revision 5

  bottle do
    sha256 arm64_sequoia:  "2d881bd765e84918db5865c5657a0399edb7908b5ee152cbe9cbe0fae4e3e83c"
    sha256 arm64_sonoma:   "97c76d5834a9f3d1279ac572e16ed5d0eb914c01562bd9c54c55e885ac88711d"
    sha256 arm64_ventura:  "9d47d49d00864f37daf0da37928b837402d98cb86205ce67bd31589e522cd2f5"
    sha256 arm64_monterey: "0c803138b913239926ff1781d19d853f534c764258cbc2a2f373c4fc3b1698c3"
    sha256 arm64_big_sur:  "7d24ece79d6792b731695618cbc2535d5e374b0cb427cb72df1a1526e04b2974"
    sha256 sonoma:         "aa0e4cacc165f4d54e69c0125c40f073792cf5aed7d1346644630dd693cb460a"
    sha256 ventura:        "44c12b64a34930933f422e9d6c602fc6067ab8fa8aafaaa9199d835d122877d7"
    sha256 monterey:       "9ea15abf7204b11e955001777e677f8858a62d9eb94e9ac98e2bc107aa260f55"
    sha256 big_sur:        "4a9a12712bedaa0ca62394a26ae842f64b4ef86108fca99c2e1712c6a7e7d9c4"
    sha256 catalina:       "33d7a1146846e30e48e637ddd64f3e7541728df03becf8175e798a8fd3eb3bab"
    sha256 mojave:         "56165e3b70f7e444bca93369b3fa4602eefb1aa4b9624ed1ecbaa4741eb7c245"
    sha256 high_sierra:    "df1b207f23b3edc587629a0fd700a446d4f8210e6a7de3bbfd3d5c122cef16f7"
    sha256 sierra:         "1770ac237a79cb0d9ae918e4bcd6d92bcca6a6695823f7a3fde6dde7d3077acb"
    sha256 x86_64_linux:   "3c5ec43c6051163260865415f7a3fc0b32b7ca6b49e56ea999ac1fe4119c75d4"
  end

  depends_on "pkgconf" => :build
  depends_on "gettext"

  # Fix CVE-2016-2399. Applied upstream on March 6th 2017.
  # Also, fixes from upstream for CVE-2017-9122 through CVE-2017-9128, applied
  # by Debian since 30 Jun 2017.
  patch do
    url "https:deb.debian.orgdebianpoolmainlibqlibquicktimelibquicktime_1.2.4-12.debian.tar.xz"
    sha256 "e5b5fa3ec8391b92554d04528568d04ea9eb5145835e0c246eac7961c891a91a"
    apply "patchesCVE-2016-2399.patch"
    apply "patchesCVE-2017-9122_et_al.patch"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system ".configure", "--enable-gpl",
                          "--without-doxygen",
                          "--without-gtk",
                          "--without-x",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.m4a")
    output = shell_output("#{bin}qtinfo #{fixture} 2>&1")
    assert_match "length 1536 samples, compressor mp4a", output
    assert_path_exists testpath".libquicktime_codecs"
  end
end