class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://ghfast.top/https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.15.3.tar.gz"
  sha256 "8cfd4d6ab47cafe931446e2c03e10df651d40487730c819f1bf420987144824f"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b12ee473cae323d284ad873f698e5d3106b5b4ec889c0ff8e768c60607d27ad2"
    sha256 cellar: :any,                 arm64_sequoia: "5a7c6a7e08ad16411cdfb035d9ab041b7a6e6cb7bbea3f5da76eeaa4e2262fb8"
    sha256 cellar: :any,                 arm64_sonoma:  "f10289b165f59ae8ef6b36d96fa77f56845cdca0720980142f3325ecb1bbd0e2"
    sha256 cellar: :any,                 sonoma:        "b4fc7383cb2109121269e77d3308c30ed7e9b3a4f688717a62f26251d2a7e56c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b2cabed7c95db0fcc44d0c0a1195b1d0433250ecf2d39aba20c18ac8fabeda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6257625e9939d4b56b7870c4fcae0e8547029438f28c02162baaf662778c7b89"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.14" => [:build, :test]

  def python3
    which("python3.14")
  end

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