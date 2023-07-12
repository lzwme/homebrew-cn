class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://ghproxy.com/https://github.com/tesseract-ocr/tesseract/archive/5.3.2.tar.gz"
  sha256 "b99d30fed47360d7168c3e25d194a7416ceb1d9e4b232c7f121cc5f77084d3e7"
  license "Apache-2.0"
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e7a2fbeb1e5a141f0146bd60ff65486c0e94415d83a6b62d0dca61cbcfd8a687"
    sha256 cellar: :any,                 arm64_monterey: "1816b1e991555cb2041e055d4afec41b717b0bb2cf238de62dbdbd4b1ee8110b"
    sha256 cellar: :any,                 arm64_big_sur:  "266cfc666e1826c545d90ab22c8abe70e8de57e1f228815260a0534c968a036f"
    sha256 cellar: :any,                 ventura:        "955413a76311dba99ee2c4051987879627f9f4fc4a842635d547cfb99de6c584"
    sha256 cellar: :any,                 monterey:       "3b0f1898dced9ef7fa1d5b47d0194c9dd20392b86124791dff9c0aef89920ab4"
    sha256 cellar: :any,                 big_sur:        "2c0b29448a1cc238ef18464fc8733c4400485123badd4aa4688489c0e72bb9b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519db9ee763b1070e572fcf57d71afc57c892043de465f11f3e8d287165be808"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "icu4c"
  depends_on "leptonica"
  depends_on "libarchive"
  depends_on "pango"

  fails_with gcc: "5"

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  resource "test_resource" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
    sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
  end

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share"

    system "make", "training"

    # make install in the local share folder to avoid permission errors
    system "make", "install", "training-install", "datarootdir=#{share}"

    resource("snum").stage { mv "snum.traineddata", share/"tessdata" }
    resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
    resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
  end

  def caveats
    <<~EOS
      This formula contains only the "eng", "osd", and "snum" language data files.
      If you need any other supported languages, run `brew install tesseract-lang`.
    EOS
  end

  test do
    resource("test_resource").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end