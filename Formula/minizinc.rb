class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://ghproxy.com/https://github.com/MiniZinc/libminizinc/archive/2.7.1.tar.gz"
  sha256 "1baa14ea5e5e1ef1931a544bf702b75a4e841c207c0cef9af18cf62c2b296045"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "211087f9578ece91af71c355dceebe5e3bdd34e3a499d8d0e724085bd3431091"
    sha256 cellar: :any,                 arm64_monterey: "8711b074857336f5b58704b5d6bfa2f66e78dffae53d059ccce0f34d23d2c978"
    sha256 cellar: :any,                 arm64_big_sur:  "c5225f86040962657f6708bc5f5635682c621f9b38b82c42b1b79ddbfa58eb76"
    sha256 cellar: :any,                 ventura:        "9f2c657f339363809cd790779d4a37e3eea6ee0ea30508896aaa023a723bbcf4"
    sha256 cellar: :any,                 monterey:       "e912cfbb70ba03e72bb5dd0778567a2989ab1dfb9214a20181d10a6129ff891c"
    sha256 cellar: :any,                 big_sur:        "bc96b4fe5e857a7b176e5a8814835f941e45ad7db2cf18b63be7c51ede841561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8924ddaa956dd8556492a91f1e36e5fff1ac4adf5171d69b0422ca16f5db0b42"
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