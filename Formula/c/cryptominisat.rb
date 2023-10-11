class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://ghproxy.com/https://github.com/msoos/cryptominisat/archive/5.11.14.tar.gz"
  sha256 "c7c50083693abcc7da528baa16e328ac0f09b5a83092ebe38d426e918200d7f3"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "3c08c9e3da22bc191469b229c408406670846606f54eca848034992904342890"
    sha256 cellar: :any,                 arm64_ventura:  "ef39a3376f881b6486dd7f8f57e7fc995d9deebc5ad1f9321d3e55d35063b757"
    sha256 cellar: :any,                 arm64_monterey: "0dd419d1f819abe881a30797be1aeba527f75c7d3f1067a1281f6ee9e92b7889"
    sha256 cellar: :any,                 sonoma:         "dafe07545e573e0d5eaf1da717ba12f78473836bbbc69417ea4e8032cddff35c"
    sha256 cellar: :any,                 ventura:        "70e442d0486a61acbbee5a864a543c3c476942b6b48de3a7e41cbaff63e00121"
    sha256 cellar: :any,                 monterey:       "ae4a08ab69b709e8b14252fa49f7e00347303d60127b0fca8e78ba4bad3489d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d53bb9d950dddfaf72828bdd98f5fbb3b3f7415c943480ac6d6acdf2e256a1c"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-toml" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "boost"

  def python3
    "python3.12"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[-DNOM4RI=ON -DMIT=ON -DCMAKE_INSTALL_RPATH=#{rpath}]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~EOS
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    EOS
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end