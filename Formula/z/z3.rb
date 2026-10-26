class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://ghfast.top/https://github.com/Z3Prover/z3/archive/refs/tags/z3-5.3.2.tar.gz"
  sha256 "df91b87822f5f8b6710af1f2419ba98758cd647dee3a8f0d070f128b47024dbe"
  license "MIT"
  compatibility_version 5
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4648a8cfb418cdd3f884b0af952b950b08f3fc21277fbd3642178285c789487"
    sha256 cellar: :any, arm64_tahoe:       "5533f25d0d271eed699c5ea730e0b1d72d4aec1c4e8a52fa6365092e178c4be9"
    sha256 cellar: :any, arm64_sequoia:     "b6f90fe3d2d1110656675771eba3019a28bd1c3cc3861baa40fb9d4ef8bc1ec5"
    sha256 cellar: :any, arm64_linux:       "96b46232484bbd95e96d83366dfdfb696863ca5c25d4a070087f523b3125cd03"
    sha256 cellar: :any, x86_64_linux:      "67fdde3c80322b8429bfb9884e1dff0fdfe153d68fb3bd8901f4af70ed4449b8"
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