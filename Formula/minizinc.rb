class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://ghproxy.com/https://github.com/MiniZinc/libminizinc/archive/2.7.3.tar.gz"
  sha256 "b8dcbaeaa4f684609829226d350c9b5885d546933e9abc7e2904110c728a362a"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fb3bdbbeb93167999530f640f204dd82e77c3045488810c5b96548bb290b9278"
    sha256 cellar: :any,                 arm64_monterey: "330b1992c8aabcd964c1d40ea63c40e168df67aa237cadcafba4d86696036bad"
    sha256 cellar: :any,                 arm64_big_sur:  "f3b29df36eda8b418835580403b89990ea16d929052beca3121bfde5e7b93345"
    sha256 cellar: :any,                 ventura:        "5481e7d641d157b80a3cb9e7a76afaa6c94e7365dcdad591dbe668cb01cea92f"
    sha256 cellar: :any,                 monterey:       "0fe7fdf7057eae4d15e85f3a9642f2b07895f8b3844b4269f43d6da1f20e9630"
    sha256 cellar: :any,                 big_sur:        "f718c82a86b3063cd9387be90982ea378e21635642c37672e9a9479d486eaf15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6e869efeb0889c30c038d2679800ef48318eee8c0ad6b5460d306a18ed53fd"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end