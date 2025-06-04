class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages9913d9f3b67b98111e79307e2a3cf6d5f73daaca002144cc6d236c4a0adbc386pymupdf-1.26.0.tar.gz"
  sha256 "ffe023f820379c84a0ddae38b0d07ea4016e1de84929491c34415520c629bcce"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1773aa238f89be9b822b1a7db7449a9f2af11ea0833cc9b5176362369308c09f"
    sha256 cellar: :any,                 arm64_sonoma:  "ffc059b2872dcd5f75ebdb39850bcd66815e1c30ef2b8a028d0b52410b513ca6"
    sha256 cellar: :any,                 arm64_ventura: "ca9a2139475f05ea6b5872dfa19eb78e8eda44d388ad6e5817f982a47e44a3f0"
    sha256 cellar: :any,                 sonoma:        "022d9e01864e2364be0cfaf53cd05cf82b292bd9453b51eef9ae01966ad63f2a"
    sha256 cellar: :any,                 ventura:       "a058db1a4e1dfd40717da1ec750ccc32c8429a08b4e58f62ecb013411bbadc69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a2561ccc1e2f9ef243da6aad55fa12c190505ef3012a5abc4c9da8bf7c55a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8b3b1bd9444ced58e46bce498113ab2e5a863abd0200d565586a4619ca55e0"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https:github.compymupdfPyMuPDFblob1.20.0setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"test.py").write <<~PYTHON
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
    PYTHON

    in_pdf = test_fixtures("test.pdf")
    out_png = testpath"test.png"

    system python3, testpath"test.py", in_pdf, out_png
    assert_path_exists out_png
  end
end