class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.04.27.00.tar.gz"
  sha256 "f5928d1cbf008b27e020ca650c75448c626d704f62bd81ba1cd932726d3232ac"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "51898d50e6868b1dd594ae0974d221e3796913dca0060318c69a5017f7d50363"
    sha256                               arm64_sequoia: "491a909ba286544b03b983a2ca28d82b813664af4e06937b3bc0fcaf524e71b4"
    sha256                               arm64_sonoma:  "ed699a2ae3fe56b8c5156cea8dc4ab73820c67758d3f0b18a64536253cac07ee"
    sha256 cellar: :any,                 sonoma:        "2996306f0f68a475bc0f15e6b163f547df115b62736259bd2c2b12cef5365118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1f22e4c58ca0f92542cb1f50a9d888720a92960e9b3b4cf20699b7700b689e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e27ff700ffd14138321b5bb13f24299cef28c47d9037db0b1af44ae85b9c8d"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    # Related: https://gitlab.kitware.com/cmake/cmake/-/issues/26773
    test_cmakelists = %w[
      eden/common/os/test/CMakeLists.txt
      eden/common/utils/test/CMakeLists.txt
    ]
    inreplace test_cmakelists, /(gtest_discover_tests\(.*)\)/, "\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = %W[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

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

    system ENV.cxx, "-std=c++20", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end