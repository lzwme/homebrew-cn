class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.12.2.tar.gz"
    sha256 "9f58f3710bd2094085951a75791550f547903d75fe7e2fcb373c5f03fc761b8f"

    # Fix source build for users with GCC 13. Remove in the next release.
    patch do
      url "https://github.com/Z3Prover/z3/commit/520e692a43c41e8981eb091494bef0297ecbe3c6.patch?full_index=1"
      sha256 "3e57b6ba3f8f271c3a8e46f1172b3384296c9570165680eb2bcf57d84e28298a"
    end
  end

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "3cefdb9b53c5f6b9bbac30630f7e2498a50d3081fd5c332b3ee48d984960129b"
    sha256 cellar: :any,                 arm64_ventura:  "f22e57323803087dbd3d716c3d637af5b3e606906027899e7428b412b2776c33"
    sha256 cellar: :any,                 arm64_monterey: "70cbff047978886125f28a24926398d2f84310039a39ba8e1d898099396606a6"
    sha256 cellar: :any,                 sonoma:         "6ab4f5b41405b259bba990f259a97f34f371a9051c9cc621a71ed97084dd87c3"
    sha256 cellar: :any,                 ventura:        "57f7090b42df9bce9b095b922ffbd4e6f2ec22f6ddb68651c16a95dc75bce6d1"
    sha256 cellar: :any,                 monterey:       "3c9f8a788f325077119a4be747f7462c2804fed4143a82e8cf35847ba7803d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e5e838aceb33a27d58731b22a71d4c6063c0c1c2ce26babe696925b4d2512c"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-setuptools" => :test

  fails_with gcc: "5"

  fails_with :clang do
    build 1000
    cause <<-EOS
      z3-z3-4.12.2/src/ast/ast.h:183:53: error: call to unavailable function 'get': introduced in macOS 10.14
          int get_int() const { SASSERT(is_int()); return std::get<int>(m_val); }
                                                          ^~~~~~~~~~~~~
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