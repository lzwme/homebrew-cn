class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https:github.comfacebookredex"
  license "MIT"
  revision 17
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
    sha256 cellar: :any,                 arm64_sequoia: "195759cd2ff485c23aef91a7be40130e2f63c7ca0cb7a492590f2c02d7094bec"
    sha256 cellar: :any,                 arm64_sonoma:  "713a4142b95031e25172e217ddfe327c38417be89c29e8cc6733ad0945abf13a"
    sha256 cellar: :any,                 arm64_ventura: "a5d162ffeaf8a98f4502b2600868e9967709fdaf79d3a901fcd41e504af2054f"
    sha256 cellar: :any,                 sonoma:        "e3e025dd6c016a786e8bc4d5f00ba047b60d18aa8395089d5156fa3f7a7c5c20"
    sha256 cellar: :any,                 ventura:       "cb91db6e0591f7d4fb6adf5a08470f6c26d709d2e04bc46c4000a37d68ace327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c03b5d6c5279fd965f95022203aeeff062d7e369eed9201c1b95062f19bcb7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.12"

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4d5bdc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83dsetuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    if build.stable?
      # https:github.comfacebookredexissues457
      inreplace "Makefile.am", "usrincludejsoncpp", Formula["jsoncpp"].opt_include
      # Work around missing include. Fixed upstream but code has been refactored
      # Ref: https:github.comfacebookredexcommit3f4cde379da4657068a0dbe85c03df558854c31c
      ENV.append "CXXFLAGS", "-include set"
      # Help detect Boost::Filesystem and Boost::System during .configure.
      # TODO: Remove in the next release.
      ENV.cxx11
    end

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

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
    rewrite_shebang python_shebang_rewrite_info(venv.root"binpython"), *python_scripts

    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          *std_configure_args
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