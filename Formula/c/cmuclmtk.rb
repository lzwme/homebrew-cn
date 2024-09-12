class Cmuclmtk < Formula
  desc "Language model tools (from CMU Sphinx)"
  homepage "https:cmusphinx.sourceforge.net"
  url "https:downloads.sourceforge.netprojectcmusphinxcmuclmtk0.7cmuclmtk-0.7.tar.gz"
  sha256 "d23e47f00224667c059d69ac942f15dc3d4c3dd40e827318a6213699b7fa2915"
  license "BSD-2-Clause"

  # We check the "cmuclmtk" directory page since versions aren't present in the
  # RSS feed as of writing.
  livecheck do
    url "https:sourceforge.netprojectscmusphinxfilescmuclmtk"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "17749777bf2cedd02ab511ce2bab36a69389ea9c1f0b03c8a92927e3e54a5fae"
    sha256 cellar: :any,                 arm64_sonoma:   "1fe5f5fcb73a7580ae29500204bc6efb7073a5b9359dbadf0b045bc358de7697"
    sha256 cellar: :any,                 arm64_ventura:  "5c31b85c5a4c5696e53b70dca952b11cd009b4c2755dd8339d1fde8b61921047"
    sha256 cellar: :any,                 arm64_monterey: "6f336006d80dbcfce530db381fb28d6207953c9ba792f71c31f041b983b85c53"
    sha256 cellar: :any,                 arm64_big_sur:  "d3069c3fbd0f41bdb0b3435b7b388f9e6051639421658663185bde9a449185b8"
    sha256 cellar: :any,                 sonoma:         "1585ae5f93e266d9189c985072808f6731b1ce52c75cc58d2caf4c27ec9edf4f"
    sha256 cellar: :any,                 ventura:        "a8e37d15ba21ee7acd391691ebf4f27b585ca9badde68492b828c1a218ef6799"
    sha256 cellar: :any,                 monterey:       "0d6891a3cb5d5be6b4071bcf68a9e3449d9a79c37b4c660f1044bbc93ecafcfa"
    sha256 cellar: :any,                 big_sur:        "e126c9d5de2e1f4e23d4fea7e8ac51c6fc2d4328a968c907879f4ea86524fbbc"
    sha256 cellar: :any,                 catalina:       "fb552e12a3c59e2ca6a9dd89e9ec229e5b815edef28093c3902fc4ee54b52207"
    sha256 cellar: :any,                 mojave:         "5c71a1746a8ca516dc5d11858a7d0d85341cafeea31797b926eba3a9ed83d9ea"
    sha256 cellar: :any,                 high_sierra:    "85a6d2a8fcad4e2b6e7d9d22ec74dd5e5f463dabc5b2f01373d3a48178b2ce6e"
    sha256 cellar: :any,                 sierra:         "716c78af6b276392a20fb02d58ff60e705509117da932d62d3ff8c6e4dd0bf5d"
    sha256 cellar: :any,                 el_capitan:     "c647327d709c3b4a93d5541f8b340d2726540c9efdcbc53d1124043c8c4989bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708324bb6cf751c76f927c6a648416ee38012499dddfc80c4b2c50cf36431c4d"
  end

  depends_on "pkg-config" => :build

  conflicts_with "julius", because: "both install `binlm2arpa` binaries"

  # Fix errors: call to undeclared function '***';
  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  patch :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system ".configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}text2wfreq", "Hello Hello Homebrew")
    assert_match "Hello 2", output
    assert_match "Homebrew 1", output
  end
end

__END__
diff --git asrclibsrr_mkdtemp.c bsrclibsrr_mkdtemp.c
index 50441ce..ee1f1c5 100755
--- asrclibsrr_mkdtemp.c
+++ bsrclibsrr_mkdtemp.c
@@ -36,6 +36,7 @@

 #include <stdio.h>
 #include <stdlib.h>
+#include <sysstat.h>

 #include <..win32compat.h>

diff --git asrcprogramstext2idngram.c bsrcprogramstext2idngram.c
index 1ec1cc2..b9ba37b 100644
--- asrcprogramstext2idngram.c
+++ bsrcprogramstext2idngram.c
@@ -53,6 +53,8 @@
 #include <string.h>
 #include <systypes.h>
 #include <errno.h>
+#include <sysstat.h>
+#include <unistd.h>

 #include "..liblmesttoolkit.h"
 #include "..libsgeneral.h"
diff --git asrcprogramstext2wngram.c bsrcprogramstext2wngram.c
index 22ba67d..2790fde 100644
--- asrcprogramstext2wngram.c
+++ bsrcprogramstext2wngram.c
@@ -41,11 +41,14 @@
 #include <string.h>
 #include <stdlib.h>
 #include <errno.h>
+#include <sysstat.h>
+#include <unistd.h>

 #include "..liblmesttoolkit.h"
 #include "..libspc_general.h"
 #include "..libsgeneral.h"
 #include "..win32compat.h"
+#include "..libsac_lmfunc_impl.h"

 int cmp_strings(const void *string1,const void *string2) {

diff --git asrcprogramswngram2idngram.c bsrcprogramswngram2idngram.c
index 3f2ba57..e363282 100644
--- asrcprogramswngram2idngram.c
+++ bsrcprogramswngram2idngram.c
@@ -47,6 +47,8 @@
 #include <string.h>
 #include <systypes.h>
 #include <errno.h>
+#include <sysstat.h>
+#include <unistd.h>

 #include "..liblmesttoolkit.h"
 #include "..libsgeneral.h"