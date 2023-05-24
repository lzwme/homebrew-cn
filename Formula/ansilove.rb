class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://ghproxy.com/https://github.com/ansilove/ansilove/releases/download/4.2.0/ansilove-4.2.0.tar.gz"
  sha256 "a2f24918ffe01332ea18b2ffab2da4ccad55c7e4a4edcf1c64a1c017d2e4e930"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b1cd439646ff1a6b8abd493458ab35b930b2182363b08b6b854674da6e9a3eaf"
    sha256 cellar: :any,                 arm64_monterey: "8dcb347e0dfda8450ab2ecbf1b402af0e867719a58a941f486c39bd3b9a562b8"
    sha256 cellar: :any,                 arm64_big_sur:  "4ca7754414ac25a1266238d0fd6335cfbf9b82c69c50047ec3cc0aa8e4f4c00c"
    sha256 cellar: :any,                 ventura:        "81f39b432fe40a1d896f2cc6a29f750da131abe4abfef5ec6769acde3af70abf"
    sha256 cellar: :any,                 monterey:       "839d25308ee9997beeb39be80f64a9e77ccc47c843e0a6ee8092bee276867688"
    sha256 cellar: :any,                 big_sur:        "53f7d9c9562a7c19d15f8ac589039f4c9e37821379bb2fca739a9b9fe6ed5ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159529146b9437684bec9aa05856f7a571950d41cc75729f75c4f760efa5c0cc"
  end

  depends_on "cmake" => :build
  depends_on "libansilove"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_predicate testpath/"output.png", :exist?
  end
end