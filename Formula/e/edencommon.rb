class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2025.08.25.00.tar.gz"
  sha256 "69fc9c723c4dbfa24ae08a5b25273a2c40654ed4058881a313036107f0d89831"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "84e6ccd6b6456b778fc3f780689784df9052d8f72c0bed062573bdf60d3694bc"
    sha256                               arm64_sonoma:  "f1242cc55a49b6457878d6b7ddb48d1d43601765ea03cf9a62aa9681c129a27a"
    sha256                               arm64_ventura: "3b3577752d15ed0e5829cea9f63666a1de76570c5d2cc347108366facf7134c5"
    sha256 cellar: :any,                 sonoma:        "a89127347c71db30556a68e63e4a0353a62cc285bec71371d775877ec83079b9"
    sha256 cellar: :any,                 ventura:       "90f5aeb20029df2d81daa3316a011767fd92ce05ef20f06389ca0fe862964a98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "834c0a23560499f4ba2d3db44c1f422334feeff8894cc3a95ed5be9f7b7e1d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4171efb2d7003fdaaf1c7d1b9b9fe9b089fb7bb6da2750f873a3df810f41a179"
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

    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
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