class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3e/06/bd008c25b210a13b8f7684d880fb7ae098d8bbbecabd6547932650a61fa0/PyMuPDF-1.22.3.tar.gz"
  sha256 "5ecd928e96e63092571020973aa145b57b75707f3a3df97c742e563112615891"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac1e5d7f12c831d1752c3a58e4023c85cd1fb5d449ad15cd9810b2ebcde25094"
    sha256 cellar: :any,                 arm64_monterey: "fa3d23e63405eee17ba5995887d52623dcb15397abb2c35d24626ddd4c0ebd25"
    sha256 cellar: :any,                 arm64_big_sur:  "6adfc071b471044cc11530cf2eea462af19edfcacd6d34750a330f16c07c3da3"
    sha256 cellar: :any,                 ventura:        "06d68bad5c9a9ad6f626ef2cdc730029034b08f20119203b4af8d7427b7528ec"
    sha256 cellar: :any,                 monterey:       "debae0c78ab56593ee5d0b1f1fab15a43429e0a1f32eb0004c9232a80b526a12"
    sha256 cellar: :any,                 big_sur:        "43efd9d6c5b4f8a1b43a2574ce70524631dcf8929952bb3206fe91641add3c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900495ca0124336a90fe459ccc9dcdbf3bbf0493ff1b263614c08a37d704a7c9"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.11"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.11"
  end

  def install
    # Fix hardcoded paths so they work on Linux and non-default prefixes.
    inreplace "setup.py" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! %r{/usr(?!/local)}, HOMEBREW_PREFIX
    end

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""

    system python3, *Language::Python.setup_install_args(prefix, python3), "build"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import sys
      from pathlib import Path

      import fitz

      in_pdf = sys.argv[1]
      out_png = sys.argv[2]

      # Convert first page to PNG
      pdf_doc = fitz.open(in_pdf)
      pdf_page = pdf_doc.load_page(0)
      png_bytes = pdf_page.get_pixmap().tobytes()

      Path(out_png).write_bytes(png_bytes)
    EOS

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end