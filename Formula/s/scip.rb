class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-10.0.1.tgz"
  sha256 "1a8a14dc28064748eabcde82c09978d07fc1005f8bc7a8be1a8bc092b7dbfe68"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/scipopt/scip"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e3a448087a508c3b7a12c5f384013856a4add67f5fbb86c33efbc817ea39435"
    sha256 cellar: :any,                 arm64_sequoia: "599be8b5733dca2f3f532348ab233b1bbb06dbd6a675b8701b76602a3df31f2f"
    sha256 cellar: :any,                 arm64_sonoma:  "8120e5baf50d55d910564b92180e9e504c1c670bd7f17d349e5dc3af64ad296a"
    sha256 cellar: :any,                 sonoma:        "f0a75e409f5b2dab85d0c4c6880c9f435d843ba5578599179a88495054ceeeb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c580aceada57527484f3adb8753730e8e4b3341476cd2ea509d4fa67b112615f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2453826968de5894e42ed135f49276d291ac44fa7e0ca1472016d13d72d73e66"
  end

  depends_on "cmake" => :build
  depends_on "papilo" => :build # for static libraries
  depends_on "soplex" => :build # for static libraries
  depends_on "cppad" => :no_linkage
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "mpfr"
  depends_on "openblas"
  depends_on "readline"
  depends_on "tbb"

  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
  end

  on_linux do
    depends_on "boost" => :no_linkage
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZIMPL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "check/instances/MIP/enigma.mps"
    pkgshare.install "check/instances/MINLP/gastrans.nl"
    pkgshare.install "check/instances/MIPEX/flugpl_rational.mps"
  end

  test do
    expected = "problem is solved [optimal solution found]"
    assert_match expected, shell_output("#{bin}/scip -f #{pkgshare}/enigma.mps")
    assert_match expected, shell_output("#{bin}/scip -f #{pkgshare}/gastrans.nl")

    command = "set exact enable TRUE read #{pkgshare}/flugpl_rational.mps optimize quit"
    assert_match expected, shell_output("#{bin}/scip -c \"#{command}\"")
  end
end