class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https:github.comfacebookexperimentaledencommon"
  license "MIT"
  head "https:github.comfacebookexperimentaledencommon.git", branch: "main"

  stable do
    url "https:github.comfacebookexperimentaledencommonarchiverefstagsv2025.06.23.00.tar.gz"
    sha256 "17ee1df6339c5a6f3addc6e1291c17e8ecc6fb78d8fb973386940115d9b709e8"

    # Include missing headers in `SessionInfo.h`
    patch do
      url "https:github.comfacebookexperimentaledencommoncommitaa34e40bf1d7b37178a6d56e9de8a43777171316.patch?full_index=1"
      sha256 "f9ad9d2f18a65968cb5f981336a970fd3ad7d1e27a1d6c1976c8de8db9e984e1"
    end
  end

  bottle do
    sha256                               arm64_sequoia: "c26a939886dd88c4b9bb6513290606a12d6a796438a3cac5f99c3ef1671f642a"
    sha256                               arm64_sonoma:  "05155bc106b57b769b11dbc3da54673c02e0fc21554000b13861f82a18326be5"
    sha256                               arm64_ventura: "2ac0a00af0fe17e2031141fea40ca644e1a38593442a2ae949b0f4865135bf33"
    sha256 cellar: :any,                 sonoma:        "c8bf7887486ba015473e3836cf97f26fff6027db9781ce519834bde5941c2492"
    sha256 cellar: :any,                 ventura:       "4327305fb0d4200a8671bcb3df4ed422dac7be6c84527f664bba1e6a88786c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "802dc7e6f52eb888d047d2854003392c09e37cbc9325643ba44d4ac99a89bb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb0f53069c1f15aa9d085e770e55b53173f5ad3ff340aabd225774190eccadb"
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
    (testpath"test.cc").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output(".test #{Process.pid}")
  end
end