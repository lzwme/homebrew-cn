class Grok < Formula
  desc "DRY and RAD for regular expressions and then some"
  homepage "https:github.comjordansisselgrok"
  url "https:github.comjordansisselgrokarchiverefstagsv0.9.2.tar.gz"
  sha256 "40edbdba488ff9145832c7adb04b27630ca2617384fbef2af014d0e5a76ef636"
  license "BSD-2-Clause"
  revision 2
  head "https:github.comjordansisselgrok.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+\.\d{,3}(\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b69e6b4812e82ce6007eda960673dc824e554fc8fea8c2a49968101b622dc11d"
    sha256 cellar: :any,                 arm64_monterey: "2556c5995021bc02cf5a41c99bd30e127dedb7350972333c0bf77b695ed94114"
    sha256 cellar: :any,                 arm64_big_sur:  "172f626c4eb3d62d2f7b7dcd2c94a4890cc69a835ae3f33ddcb7b74762e4c52e"
    sha256 cellar: :any,                 ventura:        "27073a9a9c34b78a3c7549d5709c371859b6612ed4a7dbd3a6eaf9de0707112a"
    sha256 cellar: :any,                 monterey:       "111ecef9c1d93f0e737f47a7053ae84f5b434ae2bf808a49c7fbb9f9e4bb65e1"
    sha256 cellar: :any,                 big_sur:        "02386bec2f8e4ac68e44c67c33a2a296457a8f055fbf0f177a78137b63a030ce"
    sha256 cellar: :any,                 catalina:       "8e3f44420143e731799d52290c9823a42a1833c4bc51906af59d4cd7c284f391"
    sha256 cellar: :any,                 mojave:         "b78cf21dd67826d14d99188e631ff1c431913744d91089c4cefd9b3c9e9d9a46"
    sha256 cellar: :any,                 high_sierra:    "41889afb55bfcf1d8b41eda76ef2272d29225f4cc4a5690bd409198417d7cf98"
    sha256 cellar: :any,                 sierra:         "32dc46849684918dad9ca9005ca43b092de84b16a0837049146948379301b1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2501596389a8ac61df64de2e691157b1e5383a19719f3ddbc42c661929abf1d3"
  end

  depends_on "libevent"
  depends_on "pcre"
  depends_on "tokyo-cabinet"

  uses_from_macos "gperf" => :build

  on_linux do
    # Fix build with newer gperf.  Upstream issue:
    # https:github.comjordansisselgrokissues29
    # Patch upstreamed here:
    # https:github.comjordansisselgrokpull44
    patch :DATA
  end

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(LDFLAGS) $^ -o $@", "$^ -o $@ $(LDFLAGS)" unless OS.mac?

    # Race condition in generating grok_capture_xdr.h
    ENV.deparallelize
    ENV["GPERF"] = Formula["gperf"].opt_bin"gperf" unless OS.mac?
    system "make", "grok"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin"grok", "-h"
  end
end

__END__
diff --git aMakefile bMakefile
index adfe869..182e015 100644
--- aMakefile
+++ bMakefile
@@ -213,8 +213,8 @@ grok_capture_xdr.h: grok_capture.x
 	rpcgen -h $< -o $@
 
 %.c: %.gperf
-	@if $(GPERF) --version | head -1 | egrep -v '3\.[0-9]+\.[0-9]+' ; then \
-		echo "We require gperf version >= 3.0.3" ; \
+	@if $(GPERF) --version | head -1 | egrep -v '3\.[1-9]+' ; then \
+		echo "We require gperf version >= 3.1" ; \
 		exit 1; \
 	fi
 	$(GPERF) $< > $@
diff --git agrok_matchconf_macro.h bgrok_matchconf_macro.h
index 85876f6..f1fe1f3 100644
--- agrok_matchconf_macro.h
+++ bgrok_matchconf_macro.h
@@ -19,6 +19,6 @@ struct strmacro {
 #endif
 
 * this function is generated by gperf *
-const struct strmacro *patname2macro(const char *str, unsigned int len);
+const struct strmacro *patname2macro(const char *str, size_t len);
 
 #endif * _GROK_MATCHCONF_MACRO_ *