class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://ghfast.top/https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.7.tar.gz"
  sha256 "bb04d783dda4bba58de4004afd51d65b1fa4e8d9714c88c129cac312e267152e"
  license "MPL-2.0"
  revision 1
  head "https://github.com/MiniZinc/libminizinc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ac4f53c6ae17c13b7ea6d36af7fd1ecc293720e7b71d849562866278a7657bc8"
    sha256 arm64_sequoia: "801cc61bce332def44d2ad597b910f32e2f485ee1debc9d090d23ade27bbef77"
    sha256 arm64_sonoma:  "582b2200fc4861295d1f7174b0471d9af47ecc876d17b24bffb7ea7cb7e9e4e4"
    sha256 sonoma:        "59578421371731a4157f07ebd0cb7868b6492daed472da35b6e491cef138a013"
    sha256 arm64_linux:   "f869468743e4d113873acc0b099ef41dccc543a27d812a44538a17e095acf5d0"
    sha256 x86_64_linux:  "09e14a9e1da32d22fd7ac88c6649dcaaab367a5575a513670ac56ff77fa56676"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  conflicts_with cask: "minizincide", because: "both install `minizinc` binaries"

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