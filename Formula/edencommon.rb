class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.07.17.00.tar.gz"
  sha256 "938169430f709a057eeec524debf9c248db7a36b0ebc849b2f975edea27998ea"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a15a804401f6731f4a87770bff4e92ecf7f8e002962ebe591eb85774de9c5eb"
    sha256 cellar: :any,                 arm64_monterey: "195250b234f4d89f31cc526beda04a58435cf446f5178de01173aeb8308bb7fb"
    sha256 cellar: :any,                 arm64_big_sur:  "9df59fa99eae35509f321aa97af18bebf9b3ea8b3869308b60a463bf74f08436"
    sha256 cellar: :any,                 ventura:        "ca0d7f3761392a35c86272accc56cfc2c5dd0681ab6b4aafcfb5bb97c3993fa4"
    sha256 cellar: :any,                 monterey:       "4397bd95492c8f8a618e2b51bbdf94f66d40e78f04ebee9e378f4fbe92645242"
    sha256 cellar: :any,                 big_sur:        "301f3a6be530e01367761c8334390c49b3f40abf02d095614f2faee1336f5077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0baada99e7f2e3451c286240d509ba332438b86a2255c68a9bc7f21a81c2bacd"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 30)"

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <eden/common/utils/ProcessNameCache.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      ProcessNameCache& getProcessNameCache() {
        static auto* pnc = new ProcessNameCache;
        return *pnc;
      }

      ProcessNameHandle lookupProcessName(pid_t pid) {
        return getProcessNameCache().lookup(pid);
      }

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << lookupProcessName(pid).get() << std::endl;
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