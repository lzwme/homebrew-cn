class Libicns < Formula
  desc "Library for manipulation of the macOS .icns resource format"
  homepage "https:icns.sourceforge.io"
  url "https:downloads.sourceforge.netprojecticnslibicns-0.8.1.tar.gz"
  mirror "https:deb.debian.orgdebianpoolmainlibilibicnslibicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  license any_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4f513b025e1f28cadb969f9546d4b9c0b77021310a3b634c0f6edf2ddcbb8c93"
    sha256 cellar: :any,                 arm64_sonoma:   "2da2b5cfc0aa4e79abe85f5794115e41709297c1d6d813c04ebfc5776e974b39"
    sha256 cellar: :any,                 arm64_ventura:  "144537e569ff40707cbb02a4d5d14592bc001cc7eff0e21f102dfd6c36908689"
    sha256 cellar: :any,                 arm64_monterey: "b9e9bde24513deaf1b8b09089b691c3108f0d3e456f6cdaf29851f138a9b75f7"
    sha256 cellar: :any,                 arm64_big_sur:  "163ac60e31105b323182e807195977f27bf0e7870b151d9744a1bbbd2a37b78e"
    sha256 cellar: :any,                 sonoma:         "5abbb72a1c8631d30b54ea627c2548f7501b2ad1d958c8ee4ccb9abfe5862a2d"
    sha256 cellar: :any,                 ventura:        "0b9b72d44a2d0737fe8f9c0fcca4250436b618cb437a6fb9715b2817220c180a"
    sha256 cellar: :any,                 monterey:       "53d553054ef00243c22ae45d5b4937b11c2427064b083420b95090f96855ec94"
    sha256 cellar: :any,                 big_sur:        "43f30bf4451dbc02f68bb4befc43ed730dc2d5757306111b62d37005ab45bb74"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "86cdaaef4ee42294bb74455c92d6581d84189df3231686354316a9286a651742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6738c70d5d8f9025be9ba3cd49b1e2b2510b6c05b6a27b7605e39d60e27566df"
  end

  depends_on "jasper"
  depends_on "libpng"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Fix for libpng 1.5
    inreplace "icnsutilspng2icns.c",
      "png_set_gray_1_2_4_to_8",
      "png_set_expand_gray_1_2_4_to_8"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system ".configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include "icns.h"
      int main(void)
      {
        int    error = 0;
        FILE            *inFile = NULL;
        icns_family_t  *iconFamily = NULL;
        icns_image_t  iconImage;
        return 0;
      }
    C
    system ENV.cc, "-L#{lib}", "-licns", testpath"test.c", "-o", "test"
    system ".test"
  end
end