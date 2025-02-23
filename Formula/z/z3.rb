class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https:github.comZ3Proverz3"
  url "https:github.comZ3Proverz3archiverefstagsz3-4.14.0.tar.gz"
  sha256 "63430c3aab76f75b1d2c53177f94351caeca26e218f4cc060a1fc029059af683"
  license "MIT"
  head "https:github.comZ3Proverz3.git", branch: "master"

  livecheck do
    url :stable
    regex(z3[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f1560108f24911160e1df9aacbe876e583707b4647f51d830a1d660845183da"
    sha256 cellar: :any,                 arm64_sonoma:  "18bdbf244edc945b7f1c8f8a53e3b608884f46cc35fa9bbb2d17f438bab882c5"
    sha256 cellar: :any,                 arm64_ventura: "bdc2d6f403ce4b791217d622573aa48ff1da6f10127b38abcaf52cae653e2c5b"
    sha256 cellar: :any,                 sonoma:        "0d091791e14b23d1e296861e13063b67fde37d42c6870567196e83ac69611b93"
    sha256 cellar: :any,                 ventura:       "089035bcdb9064fe7e43550afcad316eb0e16663cfc61a1076ba36aa76dc14a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4a74b790e8de5c4b18ad8a6f1266e1f108f021c7c53f4595220ecb5bc69d8c"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.13" => [:build, :test]

  fails_with :clang do
    build 1000
    cause <<~EOS
      Z3 uses modern C++17 features, which is not supported by Apple's clang until
      later macOS (10.14).
    EOS
  end

  def python3
    which("python3.13")
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

    system "make", "-C", "contribqprofdiff"
    bin.install "contribqprofdiffqprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare"examplesctest_capi.c", "-I#{include}",
                   "-L#{lib}", "-lz3", "-o", testpath"test"
    system ".test"
    assert_equal version.to_s, shell_output("#{python3} -c 'import z3; print(z3.get_version_string())'").strip
  end
end