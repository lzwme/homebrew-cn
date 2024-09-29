class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https:github.comZ3Proverz3"
  url "https:github.comZ3Proverz3archiverefstagsz3-4.13.2.tar.gz"
  sha256 "fd7dc6dd2633074f0a47670d6378b0e5c28c2c26f2b58aa23e9cd7f0bc9ba0dc"
  license "MIT"
  head "https:github.comZ3Proverz3.git", branch: "master"

  livecheck do
    url :stable
    regex(z3[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f4b81055dbb4c6e3708e4aa0dcc8a7baaab942c8b9772ecdb6aaca1af353619"
    sha256 cellar: :any,                 arm64_sonoma:  "55121730681bf2349143b67338a6e0b52699bf5971b1d84c7000f8adee88eeca"
    sha256 cellar: :any,                 arm64_ventura: "0b9a596390c9a83e653570207da252c112686f2bd5830402344484c078dbcc80"
    sha256 cellar: :any,                 sonoma:        "94aada2f85c342540f4b425ea3b6941a6633df32ec1f7278e60ffa0cdc013bd2"
    sha256 cellar: :any,                 ventura:       "dbcf1085e646a4cf61c9f417216f551584757142096414188927d8d1b922ce8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d43bfacaa16b6ef226b8af1c7cbf7efdcc7b5ef1f3d544c8316fa84840d070"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.12" => [:build, :test]

  fails_with gcc: "5"

  fails_with :clang do
    build 1000
    cause <<-EOS
      Z3 uses modern C++17 features, which is not supported by Apple's clang until
      later macOS (10.14).
    EOS
  end

  def python3
    which("python3.12")
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