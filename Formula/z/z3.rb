class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https:github.comZ3Proverz3"
  url "https:github.comZ3Proverz3archiverefstagsz3-4.15.1.tar.gz"
  sha256 "ebf6eed5f2cb217d62abddaa94526189ae40bf3c415fb9c2e2128e099f16fda0"
  license "MIT"
  head "https:github.comZ3Proverz3.git", branch: "master"

  livecheck do
    url :stable
    regex(z3[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d19f7447a80f307621a2b3d6ae90b8698cacd6e866d7a879ac0ab75a00384ae0"
    sha256 cellar: :any,                 arm64_sonoma:  "bee07526673e8ce17a9b77cbd39d7ce8496013b2f0771e825961ca0845d20018"
    sha256 cellar: :any,                 arm64_ventura: "4f60a16a1697703cd177121c9b7ea35c455b1feb941f39a3e3e97a19db30be86"
    sha256 cellar: :any,                 sonoma:        "ff50e422f6ab713da9548ec278afbef6e4d36788a337548c5f33f35fd43609c6"
    sha256 cellar: :any,                 ventura:       "1d2e608e99a850f8d1bb5c99ae2951b9f06b76475387f4cd6b6b1f4bf840c812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7448874dcaad82beb35e44fe42cfa03d121e5aeaf1f769314c60d871271dac33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3a2ff4a356931244f900557023d57b862b4953ca38f3b107ceaa32fd6fa176b"
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