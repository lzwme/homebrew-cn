class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://ghproxy.com/https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.8.0.tar.gz"
  sha256 "5f9a77a61e60ed524ebb8cbc8d54bab5756fccca8cc62400ad86ad4e720120be"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efb8b92909dfbeeab1f45ecc57f8659ac0e40951c94efea7ff7c72b6670986a6"
    sha256 cellar: :any,                 arm64_ventura:  "d7c181d841f6af9f2b7b0574eda2ab978f8e9ddcddbbede19bb54bdac2db450a"
    sha256 cellar: :any,                 arm64_monterey: "e997314f1ea05b172753d88f53f1ca63cf00ffe1d7770f718107bd45ffc16571"
    sha256 cellar: :any,                 sonoma:         "c66780fc933aa9f6ce0f23d264cadee2059f55bf0b5e6c6d816200b3efb36257"
    sha256 cellar: :any,                 ventura:        "23f15ff8b2760c5a721d9d14697a99be8f8c2d5b79b4c3ca43eb70f96df2b57a"
    sha256 cellar: :any,                 monterey:       "bdba9e505b15a502130ed345c288170d355021f1c5ce07690cf92c7f3da8a5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd4ef1aaf19354a657630a71893ae63308089623b748b4bf14101cfaeba9cd0"
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