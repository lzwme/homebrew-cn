class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://tesseract-ocr.github.io/"
  url "https://ghfast.top/https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.5.3.tar.gz"
  sha256 "9218e62793116d42a9f6d14cd9348518b27f382096eea3d0f2d1a24616bb5884"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "28b1ec8bc20c7ba5ea65221466d923a559ea7545cfb01b49d98755c97c8c21dc"
    sha256 arm64_tahoe:       "0c8bcbe7f7f01a3efd9e04eb1252c09e3a68beac94ea78ad555720b7c50e25f0"
    sha256 arm64_sequoia:     "d4356db8fc84e1ebf65c4b5e9d80857f8e346db44c7d5d566dd858450a7ede5d"
    sha256 arm64_linux:       "bdd30996a3f45cc8110285efa114907498ed173d12da3ad64413f35f38152c4e"
    sha256 x86_64_linux:      "2c1f05e3f06997ae0468e81a406505a842f979c982a393a5e83953b4a4bf4f38"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "harfbuzz"
  depends_on "icu4c@79"
  depends_on "leptonica"
  depends_on "libarchive"
  depends_on "pango"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
  end

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.1.0/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "homebrew-test_resource", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
    sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
  end

  # Test downloads a sample image to OCR
  allow_network_access! :test

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--datarootdir=#{HOMEBREW_PREFIX}/share",
                          "--disable-silent-rules",
                          *std_configure_args

    system "make", "training"

    # make install in the local share folder to avoid permission errors
    system "make", "install", "training-install", "datarootdir=#{share}"

    resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
    resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
  end

  def caveats
    <<~EOS
      This formula contains only the "eng" and "osd" language data files.
      If you need any other supported languages, run `brew install tesseract-lang`.
    EOS
  end

  test do
    resource("homebrew-test_resource").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end