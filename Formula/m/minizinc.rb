class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://ghproxy.com/https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.1.tar.gz"
  sha256 "b4fe3e0b4e51146e4b8af78b85ed53e169bc4e6401105adcd65d83cc9a92d84e"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7fef7ac57cb4072625d8afde8b4fa756040a59c64b4fda9f1383f2b1552a0259"
    sha256 cellar: :any,                 arm64_ventura:  "c15248a702af2b0e274f8cb1a7324830b07dd83145b8f3fc667b7854dec2997b"
    sha256 cellar: :any,                 arm64_monterey: "5f67897ab0584e05afaedc8cde6a1d3d24b2cd159efe960108dce973e4077d10"
    sha256 cellar: :any,                 sonoma:         "2269df281b13272f1f1aec8ad1a160f919218f2de6e59dc38704eaaec80ead68"
    sha256 cellar: :any,                 ventura:        "6566962ada8628589f4d23216952c27fa02c5b26501dce2d4ce222aab5a9f2e3"
    sha256 cellar: :any,                 monterey:       "5706f30be603c04d7db22117b2d6a7191cd3779be75e8ec672968b569453e49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e4f6d37bc1d724fef1a5552dc0da7b11c3745c8b4562087836e1ebe424c590"
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