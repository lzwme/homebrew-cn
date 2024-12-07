class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesd29eec6139116b551922789eb72e710371ddd770a2236fbd5302c2a58670ebbcpymupdf-1.25.0.tar.gz"
  sha256 "9e5a33816e4b85ed6a01545cada2b866fc280a3b6478bb8e19c364532adf6692"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bf25283fa3c5cac15aac6ceae8cf21a453ce0e5d262cd33e3cb0c5c61b04bd3"
    sha256 cellar: :any,                 arm64_sonoma:  "658c1af105b0e04459661c957a89da3c88d1e41c17a0d71698f9ce12c3048f5c"
    sha256 cellar: :any,                 arm64_ventura: "df735af404008080316a71ce707e956b2ec97f198b43f1fcf3de05d88c191159"
    sha256 cellar: :any,                 sonoma:        "b332010dd3ea76c8edf92d6ef81cf3b5e383a67442f71e3f2f507f3401bfa517"
    sha256 cellar: :any,                 ventura:       "b7087c63a343959719e9080b696d78a6876b26557fb5cbe73ad8153b56574a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d92eb542ce63a3f0f390ceb4057eb20c44dbbcbe2fb5b1df85279f3e757a30d"
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