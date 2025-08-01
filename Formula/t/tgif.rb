class Tgif < Formula
  desc "Xlib-based interactive 2D drawing tool"
  homepage "https://sourceforge.net/projects/tgif/"
  url "https://downloads.sourceforge.net/project/tgif/tgif/4.2.5/tgif-QPL-4.2.5.tar.gz"
  sha256 "2f24e9fecafae6e671739bd80691a06c9d032bdd1973ca164823e72ab1c567ba"
  license "QPL-1.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia:  "d25b56e8a0c3f77e501a9a9bb0e1214a0c50b28885be6971ad522d6d18bf54fb"
    sha256 arm64_sonoma:   "c50b1a8d587e78480c0b90da2aac56ff3439668b3d59fa44e2ba1ee1cc2a2674"
    sha256 arm64_ventura:  "27cafeb5046eb26fd967d69564c384d1a8e3ae9aabe890d3337f791d3fbc1f48"
    sha256 arm64_monterey: "82ff8e9a80be770347e07f11fc83c8fdc06856200cc5507b020ada88368f258c"
    sha256 arm64_big_sur:  "29699e47040d83ff53dbe9800a053ba9a41fe1ae1834e08ede2844ec59803662"
    sha256 sonoma:         "b3f55a3692aec31ac03d2316f72305fdc736a1935ed69e98dcf1ab8183e316cc"
    sha256 ventura:        "c06f7f0460e80628f7e8071322ea3813cd3bc12d21f9843ee58f4e397626de19"
    sha256 monterey:       "3b5ab882fc7b33701cbb6c8340c1c423afe3b088f5c34b6bee69a9bc9cf27d39"
    sha256 big_sur:        "0488ea1c1291ea86653e1f5e3b0a9d7499ee101ccec3a5cb8f1e855aa445181d"
    sha256 catalina:       "ce5a689942aed9986f74150bddebb09a129aba97810658fc67a6060519eacd86"
    sha256 mojave:         "3ab28b39b5a4b0c5cea21b096c0e8b2317725f8b6da6455ab365e8d13ac644a4"
    sha256 high_sierra:    "9c35ee5713a7efcdedb42d4602213dd94e84385bb8c5b0f9331706d6e897d08c"
    sha256 arm64_linux:    "071bd8c29e292d980e4bc1cc1898406b6fb7b4133ac91d8b892bfac23c905d65"
    sha256 x86_64_linux:   "e399c02348529aca39dfe252f2ee3e31fecb290d79599609abf4097c0b06afb8"
  end

  depends_on "libice"
  depends_on "libidn"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxmu"
  depends_on "libxt"

  uses_from_macos "zlib"

  # patch sent upstream to the author email (bill.cheng@usc.edu)
  # fixes the -Wimplicit-function-declaration error on Sonoma
  patch :DATA

  def install
    # Workaround for newer Clang
    inreplace "Makefile.in", "-Wall", "-Wall -Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.obj").write <<~EOS
      %TGIF 4.2.5
      state(0,37,100.000,0,0,0,16,1,9,1,1,0,0,1,0,1,0,'Courier',0,80640,0,0,0,10,0,0,1,1,0,16,0,0,1,1,1,1,1088,1408,1,0,2880,0).
      %
      % @(#)$Header$
      % %W%
      %
      unit("1 pixel/pixel").
      color_info(11,65535,0,[
        "magenta", 65535, 0, 65535, 65535, 0, 65535, 1,
        "red", 65535, 0, 0, 65535, 0, 0, 1,
        "green", 0, 65535, 0, 0, 65535, 0, 1,
        "blue", 0, 0, 65535, 0, 0, 65535, 1,
        "yellow", 65535, 65535, 0, 65535, 65535, 0, 1,
        "pink", 65535, 49344, 52171, 65535, 49344, 52171, 1,
        "cyan", 0, 65535, 65535, 0, 65535, 65535, 1,
        "CadetBlue", 24415, 40606, 41120, 24415, 40606, 41120, 1,
        "white", 65535, 65535, 65535, 65535, 65535, 65535, 1,
        "black", 0, 0, 0, 0, 0, 0, 1,
        "DarkSlateGray", 12079, 20303, 20303, 12079, 20303, 20303, 1
      ]).
      script_frac("0.6").
      fg_bg_colors('black','white').
      dont_reencode("FFDingbests:ZapfDingbats").
      objshadow_info('#c0c0c0',2,2).
      rotate_pivot(0,0,0,0).
      spline_tightness(1).
      page(1,"",1,'').
      box('black','',64,64,128,128,0,1,1,0,0,0,0,0,0,'1',0,[
      ]).

    EOS
    system bin/"tgif", "-print", "-text", "-quiet", "test.obj"
    assert_path_exists testpath/"test.txt"
  end
end
__END__
--- a/wb.c
+++ b/wb.c
@@ -20,11 +20,12 @@
 
 #define _INCLUDE_FROM_WB_C_
 
+#include "tgifdefs.h"
+
 #if (defined(PTHREAD) || defined(HAVE_LIBPTHREAD))
 #include <pthread.h>
 #endif /* (defined(PTHREAD) || defined(HAVE_LIBPTHREAD)) */
 
-#include "tgifdefs.h"
 #include "cmdids.h"
 
 #ifdef _HAS_STREAMS_SUPPORT