class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https:www.msoos.orgcryptominisat5"
  url "https:github.commsooscryptominisatarchiverefstags5.11.15.tar.gz"
  sha256 "b2ee17e7a5c6e6843420230215b6c70923b6955f3bef1e443c40555fc59510b0"
  # Everything that's needed to runbuildinstalllink the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b87a7a208a52bd6253e8f47b49c0a277700628c9af0293c0c82d100a3eceee8e"
    sha256 cellar: :any,                 arm64_ventura:  "d77b4a5cbeb24530a55fe05dce138f889e5b5fad23796f4928022c8096a06c2c"
    sha256 cellar: :any,                 arm64_monterey: "81cba00a0bee6bbbd1dfcfe84dc235ab2c7e28f5f0549d33275aeba010f86bd6"
    sha256 cellar: :any,                 sonoma:         "345b65beb7ba423bd4989f4b030c94529f483597cc83575d0fbd44dfdce71900"
    sha256 cellar: :any,                 ventura:        "26f96c1edf38401c76ca6503ef4b57b30f70f45ed16bc0b6f32658fee77b446f"
    sha256 cellar: :any,                 monterey:       "0373ea256fff28c5965199ce3b0fb868b245178d103ca2542c5a91a16fc5ac48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f105f621a0ca0567e2891246e99c56ec8ca2c77e08e805884adf2858fde730a6"
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