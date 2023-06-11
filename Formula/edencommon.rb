class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.06.08.00.tar.gz"
  sha256 "17ee4b04541af4116c9cf5401cbfa93c9a4a8ce316f14525b90bf0ebf7317000"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1634d5e86a7246a79257ab834811d15bc91831b898cf376c071586ea134fc13"
    sha256 cellar: :any,                 arm64_monterey: "0a676c7c5448b166d43ff9ffd97f0a867b2e33c740e9ab4221791e084a5e2df3"
    sha256 cellar: :any,                 arm64_big_sur:  "fd28cd39be86b59d227eb2f4112e87b8b9f90d1ceb89cc7d0b028e079914bf6f"
    sha256 cellar: :any,                 ventura:        "e9832adeeb72317d1492bbe0dbd1cf0f1fcc52c5322e2b7cbf2a9cd79401aae0"
    sha256 cellar: :any,                 monterey:       "8048c6a68cda659c2eff1daee4068c0f36ead86e74451c0ffc416ca3bf3568b2"
    sha256 cellar: :any,                 big_sur:        "4ea21e4b7cecd99629fef0feeb4385e92b43d4e2d6b8cae4ae2e92ec5c2c0367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8035ffce7ed5fa61ab17a616c8d9b4514a15d90c9534359e0adf9ae77aa4649f"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

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