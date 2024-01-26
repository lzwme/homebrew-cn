class Redex < Formula
  include Language::Python::Shebang

  desc "Bytecode optimizer for Android apps"
  homepage "https:github.comfacebookredex"
  license "MIT"
  revision 14
  head "https:github.comfacebookredex.git", branch: "main"

  stable do
    url "https:github.comfacebookredexarchiverefstagsv2017.10.31.tar.gz"
    sha256 "18a840e4db0fc51f79e17dfd749b2ffcce65a28e7ef9c2b3c255c5ad89f6fd6f"

    # Fix for automake 1.16.5
    patch do
      url "https:github.comfacebookredexcommit4696e1882cf88707bf7560a2994a4207a8b7c7a3.patch?full_index=1"
      sha256 "dccc41146688448ea2d99dd04d4d41fdaf7e174ae1888d3abb10eb2dfa6ed1da"
    end

    # Apply upstream fixes for GCC 11
    patch do
      url "https:github.comfacebookredexcommit70a82b873da269e7dd46611c73cfcdf7f84efa1a.patch?full_index=1"
      sha256 "44ce35ca93922f59fb4d0fd1885d24cce8a08d73b509e1fd2675557948464f1d"
    end
    patch do
      url "https:github.comfacebookredexcommite81dda3f26144a9c94816c12237698ef2addf864.patch?full_index=1"
      sha256 "523ad3d7841a6716ac973b467be3ea8b6b7e332089f23e4788e1f679fd6f53f5"
    end
    patch do
      url "https:github.comfacebookredexcommit253b77159d6783786c8814168d1ff2b783d3a531.patch?full_index=1"
      sha256 "ed69a6230506704ca4cc7a52418b3af70a6182bd96abdb5874fab02f6b1a7c99"
    end

    # Fix compilation on High Sierra
    # Fix boost issue (https:github.comfacebookredexpull564)
    # Remove for next release
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "86aadd8c35002ce327547f07d1758a5b949555e8b2c55c02b5787f202c84a938"
    sha256 cellar: :any,                 arm64_ventura:  "47b418a551ec6a995193be1a5a56dde673a93f5c3f2e50958ced4fbdd3c412b7"
    sha256 cellar: :any,                 arm64_monterey: "cf5f6273c4688d21e1c61e05c9dc6fcc95e6312fedb05830cc76ae69364b7b52"
    sha256 cellar: :any,                 sonoma:         "bfe8c41b3f25f510812a4a60b47c6585754f7bb5778420451c9246b6b884357d"
    sha256 cellar: :any,                 ventura:        "504e8955566293a7b45e2a4100193e7d4c4369460660a06795cb2dc61f24279f"
    sha256 cellar: :any,                 monterey:       "0ff09c6abada7901b3c2086fa6416cbf0e3027dadbdd2abc4dc928625522057a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6ba5c29bec4a0fd5d685784dfc0bbee1db4d9b59063d870b1cdf82ea8ce422e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  def install
    if build.stable?
      # https:github.comfacebookredexissues457
      inreplace "Makefile.am", "usrincludejsoncpp", Formula["jsoncpp"].opt_include
      # Work around missing include. Fixed upstream but code has been refactored
      # Ref: https:github.comfacebookredexcommit3f4cde379da4657068a0dbe85c03df558854c31c
      ENV.append "CXXFLAGS", "-include set"
    end

    python_scripts = %w[
      apkutil
      redex.py
      toolspythondex.py
      toolspythondict_utils.py
      toolspythonfile_extract.py
      toolspythonreach_graph.py
      toolsredex-toolDexSqlQuery.py
      toolsredexdump-apk
    ]
    rewrite_shebang detected_python_shebang, *python_scripts

    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-test_apk" do
      url "https:raw.githubusercontent.comfacebookredexfa32d542d4074dbd485584413d69ea0c9c3cbc98testinstrredex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test_apk")
    system bin"redex", "--ignore-zipalign", "redex-test.apk", "-o", "redex-test-out.apk"
    assert_predicate testpath"redex-test-out.apk", :exist?
  end
end

__END__
diff --git alibresourceRedexResources.cpp blibresourceRedexResources.cpp
index 525601ec..a359f49f 100644
--- alibresourceRedexResources.cpp
+++ blibresourceRedexResources.cpp
@@ -16,6 +16,7 @@
 #include <map>
 #include <boostregex.hpp>
 #include <sstream>
+#include <stack>
 #include <string>
 #include <unordered_set>
 #include <vector>
diff --git alibredexShow.cpp blibredexShow.cpp
index b042070f..5e492e3f 100644
--- alibredexShow.cpp
+++ blibredexShow.cpp
@@ -9,7 +9,14 @@

 #include "Show.h"

+#include <boostversion.hpp>
+ Quoted was accepted into public components as of 1.73. The `detail`
+ header was removed in 1.74.
+#if BOOST_VERSION < 107400
 #include <boostiodetailquoted_manip.hpp>
+#else
+#include <boostioquoted.hpp>
+#endif
 #include <sstream>

 #include "ControlFlow.h"