class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https:github.comZ3Proverz3"
  url "https:github.comZ3Proverz3archiverefstagsz3-4.13.3.tar.gz"
  sha256 "f59c9cf600ea57fb64ffeffbffd0f2d2b896854f339e846f48f069d23bc14ba0"
  license "MIT"
  head "https:github.comZ3Proverz3.git", branch: "master"

  livecheck do
    url :stable
    regex(z3[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4be29dafaf9f041f46684866c182efd08970bd8600f6bbe43e771ca1fb6b1c87"
    sha256 cellar: :any,                 arm64_sonoma:  "61ecbfb6496b696fb9ed7aee129bc4973d3f5c127590a1c14967544a05735721"
    sha256 cellar: :any,                 arm64_ventura: "af39185d9cb16d4af24ec7781618750b1bdfcf795557dbc641403db939ed0fdb"
    sha256 cellar: :any,                 sonoma:        "8eea09139dc8827731f816d8bbd6babc9f859ab24f9eb019a7eaf1d1bab005bf"
    sha256 cellar: :any,                 ventura:       "d0e27e707910cd91decf89a28917f1bf29d4d64286204f07513efa598cf0400c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9fee510a5d1b26819ba6a1244e6f86745a117255e5ca5c8e9c8117d8b50a020"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.13" => [:build, :test]

  fails_with :clang do
    build 1000
    cause <<-EOS
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