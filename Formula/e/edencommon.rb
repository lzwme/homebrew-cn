class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.11.27.00.tar.gz"
  sha256 "097c9541009c6211863e88a335a38e3bffec44d6a910d1d4d10472739853d842"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "686ece03a0bb9e34150b55f0d6c874261346a0b581ffe81c61ec83bdcca673fe"
    sha256 cellar: :any,                 arm64_ventura:  "cb494af804f7c568a2e95f7a3b459adda13dbd5376c50c8b44a87f3012d44e9d"
    sha256 cellar: :any,                 arm64_monterey: "569357f55b4fc269f3ae95f3d0676d1e2005215c2486908aca9146a79a5893aa"
    sha256 cellar: :any,                 sonoma:         "613b5ffb9975326149eb574f27b186f4577a7949d24aa130173cb97d17d02eaf"
    sha256 cellar: :any,                 ventura:        "acb2fc367cb1eefe465d8a3a932397848f68d037800ea51c4a9fc63647708e75"
    sha256 cellar: :any,                 monterey:       "4bb428a6c9766f5ded1df10f4db6af3d585b7d3762a93ae9e8f8987eb53fa035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "790f620967a4e3bc2210f76ea1be78e022df3af08f59e8c925bebc8c787e8329"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace buildpath.glob("eden/common/{os,utils}/test/CMakeLists.txt"),
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end