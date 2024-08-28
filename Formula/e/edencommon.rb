class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.08.19.00.tar.gz"
  sha256 "e6f507bdb691573567d9f9c0c4f238aba01dc25304a27ecb006fce799df47a39"
  license "MIT"
  revision 1
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b11461f4dc2ca56f5f4dfc9684d75337677ea24e4048eb7189dfd5af9e174f2"
    sha256 cellar: :any,                 arm64_ventura:  "c696e894464a00d82fc0ee11031c88e548bd1b08425001e104a30ef5c84fa1d3"
    sha256 cellar: :any,                 arm64_monterey: "65a8c2ee72658dca3555899af09bd9947d1c7af479acf7720762cef864c05fe5"
    sha256 cellar: :any,                 sonoma:         "d87801dc49aecb3c25a2a27133542562cf47c629d2f92ccdba695b71c681251c"
    sha256 cellar: :any,                 ventura:        "669b115f2f935fbb8615ebebcebe8f1224a8334c16a11e2dd56e4cf6d45c3a29"
    sha256 cellar: :any,                 monterey:       "c2877d786920f2a5649a7007766e1542f90b63ad006b211b89160a7d4d4c0e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "297b8a48f62768dc58554267cc0aa2d1dfe0c84d47b1d222b3284766f8391cef"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
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
    inreplace buildpath.glob("edencommon{os,utils}testCMakeLists.txt"),
              gtest_discover_tests\((.*)\),
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"
    inreplace "edencommonutilstestCMakeLists.txt",
              gtest_discover_tests\((.*)\),
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
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context-mt", "-lglog", "-o", "test"
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end