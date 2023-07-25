class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.07.24.00.tar.gz"
  sha256 "4f6cc05da0be60825421c76d2d669d5d8ed2c2f37887ce26c8f89f77bd26fd3d"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e3f84bad0c91c703fefc9a07332cec72a37b6163cb974df4f56da60dd550c614"
    sha256 cellar: :any,                 arm64_monterey: "7783fda87a4f0d79979a757b461e34b8b57e3d4a8c9c5b621cc8f44cdefef52b"
    sha256 cellar: :any,                 arm64_big_sur:  "a71cf5f5f0ef45d34c7d3c0f1341b6a0bdcdf02f4511c8de46088f35f0ea889e"
    sha256 cellar: :any,                 ventura:        "a2df8501b0693ea4769210dde69bc2389ea8296a07e14cf6bd66af8dc9462d98"
    sha256 cellar: :any,                 monterey:       "beafefab91c39629c7d06d4feaf5b1d0a23f8bc43bc0dc6420f07eac79100202"
    sha256 cellar: :any,                 big_sur:        "6dd93fa38a23bb71e7142211bff618ca29316b4014e6fcb8db37128addcacb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c2e60254c8bb7e1beabfb36d5defd29d52cbb22b839e0f87fdd89112f9e9343"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  # Fix linkage against folly
  # https://github.com/facebookexperimental/edencommon/pull/10
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/b162c1b8d94b4ed49835da6d03b4d0a550082b47.patch?full_index=1"
    sha256 "99c299fa6df887d1e72aed3d60a8ca32eb2eda1897715482af8ddfa4702fe24c"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "eden/common/utils/test/CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

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