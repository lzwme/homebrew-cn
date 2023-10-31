class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.10.30.00.tar.gz"
  sha256 "e692de0b6ddb97d6415c11e9ea349da30cc95a9aa9af0d2e70b52038862d69bd"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "84bf9e958d1e8d4be673b816db259a38865ce6e09e010b8a342f77bbd531bc86"
    sha256 cellar: :any,                 arm64_ventura:  "73c6fde31deb2c22e529dafaa25d1dc78b7c49d435e331a2cd1e3b0501560598"
    sha256 cellar: :any,                 arm64_monterey: "edda55c98d93344b6a954818703bd9d7884635ab178345ba6931c0f67f950366"
    sha256 cellar: :any,                 sonoma:         "181fe7c7854d947343b784a5b12c7f25774b88235ef44f95936a391809a8a554"
    sha256 cellar: :any,                 ventura:        "c21921289dbfe4ef4ee46cc4541c7a46d60082d7defd88abbb250a3f7d803932"
    sha256 cellar: :any,                 monterey:       "180b076745dc826a24ec4859f9e322047fb8628df29f9f1896e7a5a74f97b75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00ebda2a35cec6a6fffbc547ab1c949841a8924bd45da0a254fd590f62721d3"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
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