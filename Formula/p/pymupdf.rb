class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesf9af3d5d363241b9a74470273cf1534436f13a0a61fc5ef6efd19e5afe9de812pymupdf-1.25.5.tar.gz"
  sha256 "5f96311cacd13254c905f6654a004a0a2025b71cabc04fda667f5472f72c15a0"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6403ec1f83d72f37814ecfd6bb97a282ee77da09c0c23365489a87827fb8ab13"
    sha256 cellar: :any,                 arm64_sonoma:  "785565c0fd451871fcbe8bb521ef5bfdcd9345ecf52d88778f853dabe0118834"
    sha256 cellar: :any,                 arm64_ventura: "2d44908b7480e3566706299e60cfd7368bf6cc9dd93882655f8bc837e4950c60"
    sha256 cellar: :any,                 sonoma:        "9a1f423034d94a39abd45411c9d1d4cfa913b930afc1d47be15e36d0665d635b"
    sha256 cellar: :any,                 ventura:       "b986d4b8eb5b9036f109eaf87247d06447cc1ee8219b03bec85eefd57af3ee95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f9c66135b7ad940d5ffbfbf5eabe43c69533684e2bf5d5d042bdee4224fa040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa9e18b05f1099139b172fccbeec5f0bd407b14c306cf6728ab63719ce761ef"
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