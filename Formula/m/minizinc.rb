class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https:www.minizinc.org"
  url "https:github.comMiniZinclibminizincarchiverefstags2.9.0.tar.gz"
  sha256 "0054b82772396de3a6f7ac3c1c28bba3639d59709db1e53773c586bed4f35082"
  license "MPL-2.0"
  head "https:github.comMiniZinclibminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "06dcd03d86e426d352c322aab661a8688b2bcaf72cd2ce2b96edc30414146fac"
    sha256 cellar: :any,                 arm64_ventura: "f5df63d01fc52b6f389b84282ba5e84954de95653b9ef60483b4b42a239993a0"
    sha256 cellar: :any,                 sonoma:        "3229c076da47820855ae01d841425841879ef7f977c7b59271a86df3a3c3460b"
    sha256 cellar: :any,                 ventura:       "bbf88adc8966c9ae7facbc5452b371f17016abcff006673890fd224cf985769c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85351f7cc7f24e8970babbbcd48d74be80378513b4ddd836c5fdaca179d440ce"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

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