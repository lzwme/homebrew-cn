class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.12.29.00.tar.gz"
  sha256 "46a050323f271f863e73b94dba89cb9c2ce5e3033b764102f3c3bea8ada9fa8c"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "7b8df0f264899f298d912927c60761721ac23dbbaa9168269085251c8e196f80"
    sha256                               arm64_sequoia: "eaf5cf398c43f1384f171d41ca8968e362ebc9edec9e2bfe4a185ecbe0b29a61"
    sha256                               arm64_sonoma:  "d7daf26bd638c46fc3ffb36963c88535da1a08483235807e9435932b4a522ace"
    sha256 cellar: :any,                 sonoma:        "6f889a57cacce31d1e849dbe7a17e73c216b7958fa73290a698ec20d3c803e9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3012f9a767c00edee396630c5d4c9bc20b9ceade6dc11f660a552af67d134096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a07fd3080ef40c899ebbeb49fb26fd04479bf04a5b55e5c741e47e3736384a"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
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

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = %W[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end