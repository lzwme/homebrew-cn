class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.59.03/xmlrpc-c-1.59.03.tgz"
  sha256 "bdb71db42ab0be51591555885d11682b044c1034d4a3296401bf921ec0b233fe"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f1b8216bc2bb7e862ccd66cb4a465fbbc6898d7929c40b3e3f6cf4b97bb374b6"
    sha256 cellar: :any,                 arm64_sonoma:  "4ebef865a989c7023726abd9b2a25d113820450bc03adc72b7d8f0cade99fdb0"
    sha256 cellar: :any,                 arm64_ventura: "e25a30dc29f0361012c857be321fbaeab62673c5f9911a66f7c4e62baf368f0d"
    sha256 cellar: :any,                 sonoma:        "61d6b88623b8c15ac930983262a7a500227787e734b891e8c0e16f66dec2f8ff"
    sha256 cellar: :any,                 ventura:       "1a66bba41419cdf01db559ea65f8916b9ae8fc1a980d94c38bbdea3e923f2d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89873833875863fb9e917dbff0542153d294981ac7a380b102059472b5d327cd"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  # add `srcdir` removal build patch, upstream bug report, https://sourceforge.net/p/xmlrpc-c/patches/50/
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xmlrpc-c-config", "--features"
  end
end

__END__
diff --git a/common.mk b/common.mk
index e6e79a0..eff7c79 100644
--- a/common.mk
+++ b/common.mk
@@ -368,6 +368,7 @@ $(TARGET_MODS_PP:%=%.osh):%.osh:%.cpp
 # dependency of 'srcdir'.

 srcdir:
+	rm -f srcdir
 	$(LN_S) $(SRCDIR) $@
 blddir:
 	$(LN_S) $(BLDDIR) $@