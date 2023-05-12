class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://ghproxy.com/https://github.com/MiniZinc/libminizinc/archive/2.7.4.tar.gz"
  sha256 "012f8b1b995d2f93c6cb67f4e1e5321e8666ae51bd38e65337f7351f76468996"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40c630289e524a6c759fd08d70cc3a4d72c7f09120bef8cecac69c1f0c2863e9"
    sha256 cellar: :any,                 arm64_monterey: "07f81a75a76561c66759b4cabe4ea48e6a09b5d3b3a30dd9e7d8622c511ec68f"
    sha256 cellar: :any,                 arm64_big_sur:  "b210f4db472c387010df53b07a30170f427572102cebdabf4878bbc75d79f431"
    sha256 cellar: :any,                 ventura:        "0330cc12104a8ad21216c24a5d930b2ca5ae9c058b54dc1b922f0101efe23f25"
    sha256 cellar: :any,                 monterey:       "53d11d9f67d35f8cd83ddffe5cc6a5eb3e4434c359644548ee18212a158fe73d"
    sha256 cellar: :any,                 big_sur:        "6c04e15c6509f43c3dd76ec66f9cf610488d1f5e6240c349aca92f678f0f2aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e8ad019fc9ec28ec9a83cab7f97ac936cec6f92fb4ccc981278e159b3b2821"
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