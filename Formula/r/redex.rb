class Redex < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Bytecode optimizer for Android apps"
  homepage "https:github.comfacebookredex"
  license "MIT"
  revision 18
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
    sha256 cellar: :any,                 arm64_sequoia: "b8f15cf1f0fb935d34d71a6aeab7282390ce8c1c3f0ca6ad9783e89a7f0acc51"
    sha256 cellar: :any,                 arm64_sonoma:  "255affb5c51a98d0de1325b24b542cb8fc55b130bd5a1c8b22bc4fd615c67a8f"
    sha256 cellar: :any,                 arm64_ventura: "78165bd960bb67a4f12399aae1553c10f4de1feb5c686bc9110655d3942a814f"
    sha256 cellar: :any,                 sonoma:        "e5b52de79c81d375970a72d0db41bdd21f7607427b9cde20ba2d98323aa3c94a"
    sha256 cellar: :any,                 ventura:       "89eb99c2a77acdb426c604797ab86ff3a87a9e171dada98e5661569bf2b76ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0372148b392f5c519aa86c17fc36b942d317190709e721cde2eaceab0f4082cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "python@3.13"

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

    venv = virtualenv_create(libexec, "python3.13")
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