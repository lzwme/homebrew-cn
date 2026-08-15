class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://ghfast.top/https://github.com/dellytools/delly/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "84abfb79bfbb8489758b76cab6908e6d5de586752892a07dd7d1c887027962cf"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36dfb049a4ec6f0250623be98b8145012c31628259f2a32cab858bd20ce69c8e"
    sha256 cellar: :any, arm64_sequoia: "1bd470ca188b2ccf2481b2daa13cbca247cbbba1283be2bc61f9740817e1404f"
    sha256 cellar: :any, arm64_sonoma:  "6dd826bbc9edc51025b05bd3727bd6b4ee7cf5cc0236b9de295e4ac27847dd48"
    sha256 cellar: :any, sonoma:        "1186ae403979d15544e7faff266ada6bc221a671f31a22faf85fb19b4a18b19f"
    sha256 cellar: :any, arm64_linux:   "6059e8ac3cdd5f7c454692ffa5cc41dbe30f28ea771a85208d3e3bc4e38e9ed6"
    sha256 cellar: :any, x86_64_linux:  "c8fa26582386d495bd0b4e991c63eb4aabdf99113e6281afe783e469bdfc04e1"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end