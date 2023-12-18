class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https:www.msoos.orgcryptominisat5"
  url "https:github.commsooscryptominisatarchiverefstags5.11.15.tar.gz"
  sha256 "b2ee17e7a5c6e6843420230215b6c70923b6955f3bef1e443c40555fc59510b0"
  # Everything that's needed to runbuildinstalllink the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c04cdb2da9da8e9127ffc6a2856f05f6eb0eafe510afa513f35d756e2bebf87e"
    sha256 cellar: :any,                 arm64_ventura:  "35319d54d0f1a2c590fc97b39402242df0109b174d36b26d4ac01fd36a23889e"
    sha256 cellar: :any,                 arm64_monterey: "c8fe7a1bef24037fd3246e3e62b4e8a3efe4866f4b17966cfef387c3a701e176"
    sha256 cellar: :any,                 sonoma:         "8b0b78f50e65f73bb931100fc76fb5f0b87b92e9872c4cf3dd6e6fa9d89e9579"
    sha256 cellar: :any,                 ventura:        "e5a07c974e99cff6ee34984ceacc914956a6c998a9d08081137f6914d9ff1bfe"
    sha256 cellar: :any,                 monterey:       "dd48d1edfc46e1c6b331051ace381136ac10986b7227aa27446281a31f478b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7841bd95f7af93d854ddc24a5af1308e49133e6efac66be685447f1d5cc96c2"
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
    # fix audit failure with `liblibcryptominisat5.5.7.dylib`
    inreplace "srcGitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[-DNOM4RI=ON -DMIT=ON -DCMAKE_INSTALL_RPATH=#{rpath}]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath"test.py").write <<~EOS
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