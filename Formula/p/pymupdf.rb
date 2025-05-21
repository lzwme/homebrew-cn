class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesf9af3d5d363241b9a74470273cf1534436f13a0a61fc5ef6efd19e5afe9de812pymupdf-1.25.5.tar.gz"
  sha256 "5f96311cacd13254c905f6654a004a0a2025b71cabc04fda667f5472f72c15a0"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15d310b14cac2aa4e1ed64911574c4e3f64241f79724498808de3474d73e6bf5"
    sha256 cellar: :any,                 arm64_sonoma:  "4254e549bd9081c361d46d2ac9283cc949939ac70bcdef57c66963272a5f1004"
    sha256 cellar: :any,                 arm64_ventura: "da89abf8715bd65c1011cc813a46e329bcd98d6e1be674f90e4fba8c5925ab8a"
    sha256 cellar: :any,                 sonoma:        "17247eac5a59ae228e90f74d8c4ec51c7e0510f1ba4505c4a383899c14363206"
    sha256 cellar: :any,                 ventura:       "376c7e8d8571991a0563fae34db38016535f080604088bc40c1170db580a8027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ba1004a5924247c465e688bac7c532be3a083be017aa99a5b5e14a619a3d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcca6ae5d257a94a335e57f8ad067da6ab7b30da703c5a2b7cd4e53db032ca29"
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