class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "https://www.ncftp.com/public_ftp/ncftp/ncftp-3.2.8-src.tar.gz"
  mirror "https://fossies.org/linux/misc/ncftp-3.2.8-src.tar.gz"
  sha256 "db7da662458a1643209d6869465c38ec811f8975a6ac54fd20c63a3349f7dbf4"
  license "ClArtistic"

  livecheck do
    url "https://www.ncftp.com/download/"
    regex(/href=.*?ncftp[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "164bdc8c174f830f6063b4ea03d4688aead49f7c3eb94ac65b8ff48081e1ac74"
    sha256 arm64_sonoma:  "450afa5bf09451c3857979dbf70577b84984a4eb72c84f475e5a64163259abad"
    sha256 arm64_ventura: "95020ea454e90f40b23a676b472e6c63fe1cc5b48b509f731d73562fd22e19ce"
    sha256 sonoma:        "ee78c0477c351cca5c1b38a1032b48ac9835de45a3da1c3fa336e3623aed7750"
    sha256 ventura:       "7e549bde13344ec0f9d9d6e7e636cee53dea762a82171d69771651db048c6951"
    sha256 arm64_linux:   "331dbc6bd1f73d39e9afffab9993fd83572167587c736f13177151bbd3360f64"
    sha256 x86_64_linux:  "ed8aa817bced3e29f0a3fd6017b9947817822be713bf65ad8ee5454ab6ca70c3"
  end

  uses_from_macos "ncurses"

  # fix conflicting types for macos build, sent the patch to support@ncftp.com
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--with-ncurses",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ncftp", "-F"
  end
end

__END__
diff --git a/sio/DNSUtil.c b/sio/DNSUtil.c
index 0d542bb..eb7e867 100644
--- a/sio/DNSUtil.c
+++ b/sio/DNSUtil.c
@@ -12,7 +12,7 @@
 #	define Strncpy(a,b,s) strncpy(a, b, s); a[s - 1] = '\0'
 #endif

-#if (((defined(MACOSX)) && (MACOSX < 10300)) || (defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
+#if ((defined(AIX) && (AIX < 430)) || (defined(DIGITAL_UNIX)) || (defined(SOLARIS)) || (defined(SCO)) || (defined(HPUX)))
 extern int getdomainname(char *name, gethostname_size_t namelen);
 #endif