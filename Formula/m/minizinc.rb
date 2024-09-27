class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https:www.minizinc.org"
  url "https:github.comMiniZinclibminizincarchiverefstags2.8.6.tar.gz"
  sha256 "719469473bd0ad0f667d79e35735ef8c535f64642b3565a197ed09b285a3d506"
  license "MPL-2.0"
  head "https:github.comMiniZinclibminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "adf907c9b5c260d8a969db450e3f3cae49d6aa50ccd1fc2559c789172a0122e3"
    sha256 cellar: :any,                 arm64_sonoma:  "5bf7ec3cf7331382ce08befe033fba2f08935e11378004bbde4beea5bc85024b"
    sha256 cellar: :any,                 arm64_ventura: "6f3687c8c66335e6309e1356be97f30ad3047fbaa0054a240c3dd23ae664dadd"
    sha256 cellar: :any,                 sonoma:        "ecd076a6b9e72089ff8cf0516c601fd7fba4b5bc16c4491c8dd29708c5b84c52"
    sha256 cellar: :any,                 ventura:       "df93de241331ca6a0e6420b09ce5c746abd3baf720fcefea4f38c7bd8ad2840b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d449d38266c79bcbd9ae4a7104b44195b2a36addf744590a428535fdb4bf26b2"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}minizinc --solver cbc optimise.mzn").strip
  end
end