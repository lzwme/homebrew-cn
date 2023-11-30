class Scip < Formula
  desc "Solver for mixed integer programming and mixed integer nonlinear programming"
  homepage "https://scipopt.org"
  url "https://scipopt.org/download/release/scip-8.1.0.tgz"
  sha256 "9316427fc778c4bf15298651309c6e5b334b278cfe606d1ff5668d50ba41f53f"
  license "Apache-2.0"

  livecheck do
    url "https://scipopt.org/scipdata.js"
    regex(/["']name["']:\s*?["']scip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a9ad349c0adbce84383c608b914423be1c151cb283d23e173ea615b3b2c9c6b6"
    sha256 cellar: :any,                 arm64_ventura:  "057154c75e2ba1e245ce3ab27289d118403993d0214e9c3d7462a9e10cd3c44d"
    sha256 cellar: :any,                 arm64_monterey: "c2acfa6df8138930d11b33447bb276aaef105c7154650b12618608ea457c4b97"
    sha256 cellar: :any,                 sonoma:         "16914d5666dac66cc51e4f150b15d3a0050d8783ca60381ff38eb4bb0d570059"
    sha256 cellar: :any,                 ventura:        "8ae5f19c93c4520e53968231d6983a3b5c692b4bc1fe4a3b8d8ae6550eaf807f"
    sha256 cellar: :any,                 monterey:       "781014a38d5d2a64fb0812b85d5519cdea2632d58f6fdcde3af75f7aa6cdbc3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9e48a4cb803dec9681284e1d52a892e99e144a36dd289f0e3c1b6c7ae666a0"
  end

  depends_on "cmake" => :build
  depends_on "cppad"
  depends_on "gmp"
  depends_on "ipopt"
  depends_on "papilo"
  depends_on "readline"
  depends_on "soplex"
  uses_from_macos "zlib"

  def install
    cmake_args = %w[
      -DZIMPL=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "check/instances/MIP/enigma.mps"
    pkgshare.install "check/instances/MINLP/gastrans.nl"
  end

  test do
    assert_match "problem is solved [optimal solution found]", shell_output("#{bin}/scip -f #{pkgshare}/enigma.mps")
    assert_match "problem is solved [optimal solution found]", shell_output("#{bin}/scip -f #{pkgshare}/gastrans.nl")
  end
end