class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://ghfast.top/https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.07.13.00.tar.gz"
  sha256 "e10aa3ecbdbbea51bb58b90556a801873872e652e67f3ca54aa625936a31dc8e"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "090637c742fe058d129e89ff689560710bc3ccfdbdbe99582f30ca72deccc64d"
    sha256               arm64_sequoia: "63a0e288b7ff929fe7f5512ec8ed4f0e93b0eae9f6a3a42de434668e2b58fee4"
    sha256               arm64_sonoma:  "58377d6db5189c6e37318bf905fbc973ea0297251babc1c7e16ffd40c6591c3f"
    sha256 cellar: :any, sonoma:        "9a98711181f3e548a104b5ad14d0c9a6c5f317cf35943f4a9a91d728755896a7"
    sha256 cellar: :any, arm64_linux:   "b93d9d1cf1482991e0e828bddafd21d4967a97104bfdf4ac8c670a334df5a436"
    sha256 cellar: :any, x86_64_linux:  "da8f099f46ebabc51b4a5926190604abb9a015d63fc02af9deb0de7ee3d72ff5"
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

  # GCC 13 libstdc++ no longer pulls in <string> via <string_view>.
  # PR ref: https://github.com/facebookexperimental/edencommon/pull/32
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/7dc082da238446cde535b03370be0b709701b7ac.patch?full_index=1"
    sha256 "1becb3b9bcba13f19cb697baa015bece72b0330e4beae6db5a459f4e6fbff5a5"
    type :unofficial
    resolves "https://github.com/facebookexperimental/edencommon/pull/32"
  end

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
                    "-L#{lib}", "-L#{formula_opt_lib("folly")}",
                    "-L#{formula_opt_lib("boost")}", "-L#{formula_opt_lib("glog")}", "-L#{formula_opt_lib("fmt")}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end