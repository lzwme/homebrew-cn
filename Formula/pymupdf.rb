class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3e/06/bd008c25b210a13b8f7684d880fb7ae098d8bbbecabd6547932650a61fa0/PyMuPDF-1.22.3.tar.gz"
  sha256 "5ecd928e96e63092571020973aa145b57b75707f3a3df97c742e563112615891"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fef900b7c795aad102455e180d4355a6255621caf4dc77c60276d66d9458e48"
    sha256 cellar: :any,                 arm64_monterey: "453761bbce3dde21dc77f19396695bca97f4524aa91a7d7a09dcb07c6a6a3ec4"
    sha256 cellar: :any,                 arm64_big_sur:  "ea9af1a5b06f98cd0ed9f45b53cfdbec270362218a8605c6cff5bea390be10dd"
    sha256 cellar: :any,                 ventura:        "8acd4b2a3d94e1a2df6e89a337dc7bf5fd675ddc94a98716a56fafa1e160ce67"
    sha256 cellar: :any,                 monterey:       "fbe956c71a4216e787efa81cab92f54abb959da9e86416de070411f9067e5b47"
    sha256 cellar: :any,                 big_sur:        "b52f335cfee766b0c29e96ab54beb992eb953325e8a5cabf0a4176be37301c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c49867e82dcdd02ee44167d884e1e05eab15318aad5d87fa14563c203e8419"
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