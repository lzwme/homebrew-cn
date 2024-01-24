class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.01.22.00.tar.gz"
  sha256 "0fc567fab380ba905b662b71082dd3a0aa8bbef84f22b9f7256bf80c5ead5644"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5297178e95b1531e91c4b8e98f290c918aa8e06dbc1229fc38b2e18b5b12273"
    sha256 cellar: :any,                 arm64_ventura:  "9c20ee5d08978116960d6e4719980442cbb30d77375c450c77077b760a85256c"
    sha256 cellar: :any,                 arm64_monterey: "8dcc08aa1920fdef97ed388aa4f200e30ff958ca991f0348b41dafb9991b3de1"
    sha256 cellar: :any,                 sonoma:         "0dd314c215558fb50a570a868f86921f5179bf81cee5b0b643d6fbb4a8479709"
    sha256 cellar: :any,                 ventura:        "c6490a943faace3779bcdecf9ddea0cf58a5f045759f0ce7a38000f0859e6402"
    sha256 cellar: :any,                 monterey:       "a419c01a35c328ff0a1338e147c7ca7960fa289c8d47a4368c19ba666de6c360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "729478f2b26a1d2ebd1d7d2c7f8ecb612cc9c858d6e9819da854d3bcd7d634e5"
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