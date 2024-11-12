class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages223984efca63af4e5a014c1d4c21686469f99c3d1c160a3a0b902ac676f6ffd9PyMuPDF-1.24.13.tar.gz"
  sha256 "6ec3ab3c6d5cba60bfcf58daaa2d1a5b700b0366ce52be666445007351461fa4"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c35b2247d386b64fec494fc39172c86e475fc6f48623a42877e48e8ef1380aa"
    sha256 cellar: :any,                 arm64_sonoma:  "62d9f3ed691a0c3c7d1afda4a5895b1d5b9db977495de61c95050260a70b8407"
    sha256 cellar: :any,                 arm64_ventura: "cd388aa0c4f41485ab79902755f07af3a4c46b44c5a1875092966fb996d74e28"
    sha256 cellar: :any,                 sonoma:        "31eb1223223fa179150571a184357dd9d4df2559e6c7f6dd73fd85bc446c213f"
    sha256 cellar: :any,                 ventura:       "2b8d209d365e21a73b590df712cfacdf8662fb1e11bbfa08aae2fa8d481721f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9fb6c06b5681ab77e49864665db079a0e4f3a4cd953a6474eb05edc67762a4"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
    assert_predicate out_png, :exist?
  end
end