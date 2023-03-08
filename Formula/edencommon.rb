class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.03.06.00.tar.gz"
  sha256 "7b924d29b476068318c4afe559a0baced90b8cc8bab7ffc184b76887e7836fad"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd1e211f1ca73b4236dca6bbf33f369dbb3384d1f5b58f4af16998ca9a9929e9"
    sha256 cellar: :any,                 arm64_monterey: "6b7832547aa10707e7792597572fcf2270966dfeda4ac03d011cdae1c02fa159"
    sha256 cellar: :any,                 arm64_big_sur:  "a5fd75f9acbf8dfa33c81c5fb9be9e1e76de44acaf750da9c58e20c5956804f7"
    sha256 cellar: :any,                 ventura:        "c6bfe1fdf705578dca876d9b0dc57f7198e50a2dbdc66da34d908285096af501"
    sha256 cellar: :any,                 monterey:       "29983475f0ca49134e7e2437bde6a4afc7cd4317628c6a9ac9fb7fdfcceb7c83"
    sha256 cellar: :any,                 big_sur:        "5749da841428e9964a427b6d2cccfc2915e53be76f1e602728f4b816b298fd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bda6ff8dc1f1abdead59e8ce13230c2321273dd96cbb0d3ea72a50aecac8f9a"
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