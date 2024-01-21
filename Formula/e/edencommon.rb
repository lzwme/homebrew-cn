class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.01.15.00.tar.gz"
  sha256 "9be7d8a5ced42b1e8b7414abaa02e98672f3aa514797231046f71a9a30a60b07"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "196f553057ad4052f78e6ddeeec2ef4c4e7a4617d1b3eca1f0be4294ee81545f"
    sha256 cellar: :any,                 arm64_ventura:  "3e06aeba27b5715ddf4ab7e9b856d9917ad47f5f172c5183503e4c1a41650379"
    sha256 cellar: :any,                 arm64_monterey: "8f23b30a6fd824f6474f9659130d80f32de4dba84bf3a7c77885ee1d45b10595"
    sha256 cellar: :any,                 sonoma:         "0a69cdf935f9ec5f7a5020977e26d6c8abcf130104e70e3dde574ceda71ca042"
    sha256 cellar: :any,                 ventura:        "34e7bc6be440b203ed9f457df2ba92a36c370b92897f8ed1ba1250541e7744bd"
    sha256 cellar: :any,                 monterey:       "a235d9388c61440d16d5d3dfa1eaf1b950956311cd1763dd2c6ade542b33f6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8d434977ff00c6c698cd0a150c0c883c80306b67d75b4dc2b2c714418b81e6"
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
    inreplace buildpath.glob("edencommon{os,utils}testCMakeLists.txt"),
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "edencommonutilstestCMakeLists.txt",
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath"test.cc").write <<~EOS
      #include <edencommonutilsProcessInfo.h>
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
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end