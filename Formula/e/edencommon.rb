class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "cf6d49c47893033d6f6648867da9f16bc1068db2e8af194af98119f544eaff2f"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f09685765218f82776b13343ecb92813319ab30ccaa5399cf287268c927d76ec"
    sha256 cellar: :any,                 arm64_ventura:  "3e16516956b5218805f6346c68c0d6d82306ba2ea27aacb189a44ec1e46fd6c5"
    sha256 cellar: :any,                 arm64_monterey: "39e5a1d14e188aecd368c0148b8d1f4b28c5f412674c7f97dec26997eea5972d"
    sha256 cellar: :any,                 sonoma:         "d4494e56acbd4bceef5d8125f615f9caa36ec6609bf4e95c08053ef8be92ea9f"
    sha256 cellar: :any,                 ventura:        "c742bb61fd67156250ae279bf6dcf2ca7805d897b0e8fb65beb457257eb08304"
    sha256 cellar: :any,                 monterey:       "33503a3509f0cf5d4862dbd7fff22a27001d423cdd3a01736a1f70c0011b32f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3e8c832d8842b7b35aca6cdf270b97a95e321294de49e559dbcf6265bd8424"
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