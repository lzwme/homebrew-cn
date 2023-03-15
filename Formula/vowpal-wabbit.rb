class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://ghproxy.com/https://github.com/VowpalWabbit/vowpal_wabbit/archive/9.8.0.tar.gz"
  sha256 "cfc7d43fc590dffebf0adb385560dd72735f23b9086c918e95475b341c620a9d"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ff3e93030ca988f26035e90b5a6d1354c382ac9adcdb7984de0c0d3f2ff69ce6"
    sha256 cellar: :any,                 arm64_monterey: "8108740efaf0d761ffe9cecf715b1fd80c01c08fc1813104f7db9fec591b6233"
    sha256 cellar: :any,                 arm64_big_sur:  "5f45affb33dfaf31856b7db812cb0ee404b0938a27151497ee4bdd640fffa802"
    sha256 cellar: :any,                 ventura:        "77f28f684273db1bdef2e04d665cbe4eb7655075ac4fad35b60b99192a4869e6"
    sha256 cellar: :any,                 monterey:       "65c83e129e76a29b79541420c3e99631214340018f80c09e5bc47c0260a1aae1"
    sha256 cellar: :any,                 big_sur:        "9a84fab3d23d403d1b1742d180a89bee7d275b541f7556d45e1abf9208984209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70acd56e352d8d103aa860343b8ec6d90fc5c947b50593939c0b04eb2fe49819"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fmt"

  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  patch :DATA

  def install
    ENV.cxx11

    args = %w[
      -DBUILD_TESTING=OFF
      -DRAPIDJSON_SYS_DEP=ON
      -DFMT_SYS_DEP=ON
      -DSPDLOG_SYS_DEP=ON
      -DVW_BOOST_MATH_SYS_DEP=On
      -DVW_EIGEN_SYS_DEP=On
      -DVW_SSE2NEON_SYS_DEP=On
      -DVW_INSTALL=On
    ]

    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install Dir["utl/*"]
    rm bin/"active_interactor.py"
    rm bin/"vw-validate.html"
    rm bin/"clang-format.sh"
    rm bin/"release_blog_post_template.md"
    rm_r bin/"flatbuffer"
    rm_r bin/"dump_options"
  end

  test do
    (testpath/"house_dataset").write <<~EOS
      0 | price:.23 sqft:.25 age:.05 2006
      1 2 'second_house | price:.18 sqft:.15 age:.35 1976
      0 1 0.5 'third_house | price:.53 sqft:.32 age:.87 1924
    EOS
    system bin/"vw", "house_dataset", "-l", "10", "-c", "--passes", "25", "--holdout_off",
                     "--audit", "-f", "house.model", "--nn", "5"
    system bin/"vw", "-t", "-i", "house.model", "-d", "house_dataset", "-p", "house.predict"

    (testpath/"csoaa.dat").write <<~EOS
      1:1.0 a1_expect_1| a
      2:1.0 b1_expect_2| b
      3:1.0 c1_expect_3| c
      1:2.0 2:1.0 ab1_expect_2| a b
      2:1.0 3:3.0 bc1_expect_2| b c
      1:3.0 3:1.0 ac1_expect_3| a c
      2:3.0 d1_expect_2| d
    EOS
    system bin/"vw", "--csoaa", "3", "csoaa.dat", "-f", "csoaa.model"
    system bin/"vw", "-t", "-i", "csoaa.model", "-d", "csoaa.dat", "-p", "csoaa.predict"

    (testpath/"ect.dat").write <<~EOS
      1 ex1| a
      2 ex2| a b
      3 ex3| c d e
      2 ex4| b a
      1 ex5| f g
    EOS
    system bin/"vw", "--ect", "3", "-d", "ect.dat", "-f", "ect.model"
    system bin/"vw", "-t", "-i", "ect.model", "-d", "ect.dat", "-p", "ect.predict"

    (testpath/"train.dat").write <<~EOS
      1:2:0.4 | a c
        3:0.5:0.2 | b d
        4:1.2:0.5 | a b c
        2:1:0.3 | b c
        3:1.5:0.7 | a d
    EOS
    (testpath/"test.dat").write <<~EOS
      1:2 3:5 4:1:0.6 | a c d
      1:0.5 2:1:0.4 3:2 4:1.5 | c d
    EOS
    system bin/"vw", "-d", "train.dat", "--cb", "4", "-f", "cb.model"
    system bin/"vw", "-t", "-i", "cb.model", "-d", "test.dat", "-p", "cb.predict"
  end
end

__END__
diff --git a/ext_libs/ext_libs.cmake b/ext_libs/ext_libs.cmake
index 1ef57fe..20972fc 100644
--- a/ext_libs/ext_libs.cmake
+++ b/ext_libs/ext_libs.cmake
@@ -107,7 +107,7 @@ endif()
 
 add_library(sse2neon INTERFACE)
 if(VW_SSE2NEON_SYS_DEP)
-  find_path(SSE2NEON_INCLUDE_DIRS "sse2neon/sse2neon.h")
+  find_path(SSE2NEON_INCLUDE_DIRS "sse2neon.h")
   target_include_directories(sse2neon SYSTEM INTERFACE "${SSE2NEON_INCLUDE_DIRS}")
 else()
   # This submodule is placed into a nested subdirectory since it exposes its
diff --git a/vowpalwabbit/core/src/reductions/lda_core.cc b/vowpalwabbit/core/src/reductions/lda_core.cc
index f078d9c..ede5e06 100644
--- a/vowpalwabbit/core/src/reductions/lda_core.cc
+++ b/vowpalwabbit/core/src/reductions/lda_core.cc
@@ -33,7 +33,7 @@ VW_WARNING_STATE_POP
 #include "vw/io/logger.h"
 
 #if defined(__ARM_NEON)
-#  include <sse2neon/sse2neon.h>
+#  include <sse2neon.h>
 #endif
 
 #include <algorithm>