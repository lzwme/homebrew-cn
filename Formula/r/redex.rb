class Redex < Formula
  include Language::Python::Shebang

  desc "Bytecode optimizer for Android apps"
  homepage "https://github.com/facebook/redex"
  license "MIT"
  revision 12
  head "https://github.com/facebook/redex.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/facebook/redex/archive/v2017.10.31.tar.gz"
    sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"

    # Fix for automake 1.16.5
    patch do
      url "https://github.com/facebook/redex/commit/4696e1882cf88707bf7560a2994a4207a8b7c7a3.patch?full_index=1"
      sha256 "dccc41146688448ea2d99dd04d4d41fdaf7e174ae1888d3abb10eb2dfa6ed1da"
    end

    # Apply upstream fixes for GCC 11
    patch do
      url "https://github.com/facebook/redex/commit/70a82b873da269e7dd46611c73cfcdf7f84efa1a.patch?full_index=1"
      sha256 "44ce35ca93922f59fb4d0fd1885d24cce8a08d73b509e1fd2675557948464f1d"
    end
    patch do
      url "https://github.com/facebook/redex/commit/e81dda3f26144a9c94816c12237698ef2addf864.patch?full_index=1"
      sha256 "523ad3d7841a6716ac973b467be3ea8b6b7e332089f23e4788e1f679fd6f53f5"
    end
    patch do
      url "https://github.com/facebook/redex/commit/253b77159d6783786c8814168d1ff2b783d3a531.patch?full_index=1"
      sha256 "ed69a6230506704ca4cc7a52418b3af70a6182bd96abdb5874fab02f6b1a7c99"
    end

    # Fix compilation on High Sierra
    # Fix boost issue (https://github.com/facebook/redex/pull/564)
    # Remove for next release
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eaafdcc35fbb70517593e3944edb35bbba69f23884c6757a580b3ad352eafd1f"
    sha256 cellar: :any,                 arm64_ventura:  "e25e28b448f6d3123a3ac849ffac1d88967cd02411bd85ed44e3a159085ba096"
    sha256 cellar: :any,                 arm64_monterey: "5a4a62ced9c73a9186cb2837a31880504ba64e237e0a8060751176fe3652632a"
    sha256 cellar: :any,                 arm64_big_sur:  "701f5020ad8a3a72cd7f1de913af4f4404a881a1399196ebd1468164126fe363"
    sha256 cellar: :any,                 sonoma:         "8f6a1ced2dbd16ae8d2572c5381fbedb710e6f42921aa1ecbecb3e6ca49db136"
    sha256 cellar: :any,                 ventura:        "e7ab3fc11cd1620b651767594eee62e7db9c06e0419e32ac1df5a92a3e34d79c"
    sha256 cellar: :any,                 monterey:       "97e06d7df13ac4e0ee46c295c6d28c0d19888173eee06d3f2e30a9d9b2b3fcb4"
    sha256 cellar: :any,                 big_sur:        "2dee5174ab23e7ff88913a599b63766db149848ded87f2645e976a7f3ce0fffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dfb3c6830b5a9b646e2739d446611ba476ed3c86402dbf160f11fa0f9f4de07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.11"

  resource "homebrew-test_apk" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    if build.stable?
      # https://github.com/facebook/redex/issues/457
      inreplace "Makefile.am", "/usr/include/jsoncpp", Formula["jsoncpp"].opt_include
      # Work around missing include. Fixed upstream but code has been refactored
      # Ref: https://github.com/facebook/redex/commit/3f4cde379da4657068a0dbe85c03df558854c31c
      ENV.append "CXXFLAGS", "-include set"
    end

    python_scripts = %w[
      apkutil
      redex.py
      tools/python/dex.py
      tools/python/dict_utils.py
      tools/python/file_extract.py
      tools/python/reach_graph.py
      tools/redex-tool/DexSqlQuery.py
      tools/redexdump-apk
    ]
    rewrite_shebang detected_python_shebang, *python_scripts

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-test_apk")
    system bin/"redex", "--ignore-zipalign", "redex-test.apk", "-o", "redex-test-out.apk"
    assert_predicate testpath/"redex-test-out.apk", :exist?
  end
end

__END__
diff --git a/libresource/RedexResources.cpp b/libresource/RedexResources.cpp
index 525601ec..a359f49f 100644
--- a/libresource/RedexResources.cpp
+++ b/libresource/RedexResources.cpp
@@ -16,6 +16,7 @@
 #include <map>
 #include <boost/regex.hpp>
 #include <sstream>
+#include <stack>
 #include <string>
 #include <unordered_set>
 #include <vector>
diff --git a/libredex/Show.cpp b/libredex/Show.cpp
index b042070f..5e492e3f 100644
--- a/libredex/Show.cpp
+++ b/libredex/Show.cpp
@@ -9,7 +9,14 @@

 #include "Show.h"

+#include <boost/version.hpp>
+// Quoted was accepted into public components as of 1.73. The `detail`
+// header was removed in 1.74.
+#if BOOST_VERSION < 107400
 #include <boost/io/detail/quoted_manip.hpp>
+#else
+#include <boost/io/quoted.hpp>
+#endif
 #include <sstream>

 #include "ControlFlow.h"