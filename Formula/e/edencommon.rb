class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.11.06.00.tar.gz"
  sha256 "412a2e1831b4ed2a2f8c69a8e6455fe663ae61bb0aeef1a7abee0bef857bf190"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "680fef997a25bd35a904769bc096d8b1ddbc34572b1231eeabd51aaab0cbdbe3"
    sha256 cellar: :any,                 arm64_ventura:  "22619e8c3256a3fd12c6e4e1619ef867645683ca6cc91bc7a2bfa991263946ce"
    sha256 cellar: :any,                 arm64_monterey: "9880485978add556a60a9f56ae1998f2fa5a545f92147e2d43555de0cd2693b1"
    sha256 cellar: :any,                 sonoma:         "c0e790e2de57dd9f34cba2c36c5112f3f081e2597409baf5b360b86eb5414977"
    sha256 cellar: :any,                 ventura:        "2b2a66ebd9b853b7a460368b67761452d55183af47cc033d4413bfadd30649ac"
    sha256 cellar: :any,                 monterey:       "730f1502a122adaf4b15b025bc6995852f47f96cfbaa302e6e7210c9cbe4c103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef2c53d2c82d279c170df4d49807769aab153c1483015a51e8ce29cf3a48b6b"
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