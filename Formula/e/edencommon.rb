class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghproxy.com/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2023.11.20.00.tar.gz"
  sha256 "cddcb7beac761f03430f801aa587456a3499d5c1517f0ded56337d3fba13f7a5"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da7455ca044a4d0fe713ced8271d6f7727c042467e70760ae850c9fa8c585b62"
    sha256 cellar: :any,                 arm64_ventura:  "f8fb4a59c153ee0ceac6f43e41d718fe7c9fbac80ca68426b30404eb441a7897"
    sha256 cellar: :any,                 arm64_monterey: "05abb11e5427338edfbf344e08328c8903cc6e70e5da2ee1fbdb7bff5a83703e"
    sha256 cellar: :any,                 sonoma:         "b61243f51b924bd0f589c31d12d6e028a39eb68ef6a702a3c8b1d61551e152ed"
    sha256 cellar: :any,                 ventura:        "9073c9622d3721af8db8f8d165b8631627195135850fc15a5b2208387cdc8bce"
    sha256 cellar: :any,                 monterey:       "acd9b37e786ced0a6b02536cc0831ac55dfc333bb1f7f7fe6b1617bb970d6f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ecda93c52ac347c8b86c250c9728904aa6434386fc93ea9091502c7937947f"
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