class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2024.09.16.00.tar.gz"
  sha256 "05f27cb87b8697486717010c95ecd97a3c3dd30bd166706c61ccabfacf4ab195"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4f59c58fd2eb8a45bda4966cd435b3d5c811d1aa53fd211d8b7a95ffaa5a2f0"
    sha256 cellar: :any,                 arm64_sonoma:  "f49193a5a2ca0e4721ba7478ae109e0f3cf4aa59c02888a3a2dae4da47ff425a"
    sha256 cellar: :any,                 arm64_ventura: "c3f0c7bbc96923e2014069a46cc6aa3898ed0f534ce07f885c0f008d1463194a"
    sha256 cellar: :any,                 sonoma:        "fd177d57a68a186e75321be3d4ad4a9c288db78a33321b6c3d9f8ad503d2ecdd"
    sha256 cellar: :any,                 ventura:       "7ef3562b742506dac8d89f7b423aa57196e2aca3908b36fbfccf745a99b56ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c1375e68ba55d97956f6e04f988a1a40336c23b3f4b6ebfb50c334194a880f"
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