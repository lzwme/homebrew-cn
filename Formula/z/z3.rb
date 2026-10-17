class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://ghfast.top/https://github.com/Z3Prover/z3/archive/refs/tags/z3-5.3.0.tar.gz"
  sha256 "ba9c1dd4c95a41d45d19356aa0c19813879b0bc226b8a79cb281ff7b6a1c59c8"
  license "MIT"
  compatibility_version 5
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9dbb64ac09a6433c54be5271f6008d43d2ec63ec291eac78496e3696d3c6d4cd"
    sha256 cellar: :any, arm64_tahoe:       "231979a59ac771b0a617a4273e3440dfe8ac2e54b987b1529ee995eebcbe47f1"
    sha256 cellar: :any, arm64_sequoia:     "7e756040907e4a7096229ef78e0865967d4ac6111be1b5d4337b5093c7f84e0c"
    sha256 cellar: :any, arm64_linux:       "c587a10d44fc3e09d81b346e1a8deb88c5e5b3a112e412723f954be71f21508f"
    sha256 cellar: :any, x86_64_linux:      "8c2f62946a611a326b1f6b423b0b500e626976517dc7c6ad2958f692f57ec73c"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.15" => [:build, :test]

  # The following macOS conditional should be the inverse of LLVM's Z3 conditional
  on_ventura :or_older do
    fails_with :clang do
      cause "Requires C++20 std::format, https://developer.apple.com/xcode/cpp/#c++20"
    end
  end

  fails_with :gcc do
    version "12"
    cause "Requires C++20 std::format, https://gcc.gnu.org/gcc-13/changes.html#libstdcxx"
  end

  deny_network_access!

  def install
    args = %W[
      -DZ3_LINK_TIME_OPTIMIZATION=ON
      -DZ3_INCLUDE_GIT_DESCRIBE=OFF
      -DZ3_INCLUDE_GIT_HASH=OFF
      -DZ3_INSTALL_PYTHON_BINDINGS=ON
      -DZ3_BUILD_EXECUTABLE=ON
      -DZ3_BUILD_TEST_EXECUTABLES=OFF
      -DZ3_BUILD_PYTHON_BINDINGS=ON
      -DZ3_BUILD_DOTNET_BINDINGS=OFF
      -DZ3_BUILD_JAVA_BINDINGS=OFF
      -DZ3_USE_LIB_GMP=OFF
      -DPYTHON_EXECUTABLE=#{python3}
      -DCMAKE_INSTALL_PYTHON_PKG_DIR=#{Language::Python.site_packages(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c", "-I#{include}",
                   "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
    assert_equal version.to_s, shell_output("#{python3} -c 'import z3; print(z3.get_version_string())'").strip
  end
end