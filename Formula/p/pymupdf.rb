class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesd29eec6139116b551922789eb72e710371ddd770a2236fbd5302c2a58670ebbcpymupdf-1.25.0.tar.gz"
  sha256 "9e5a33816e4b85ed6a01545cada2b866fc280a3b6478bb8e19c364532adf6692"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "01b98e9d2dfd1a75ffe427c27e3dfe7f49afee6d9adec881014431b85868cf15"
    sha256 cellar: :any,                 arm64_sonoma:  "fd51ca8db558acfb6a3ecfc1243f90ad00a7658b11d8dd8dcc0f51f22f4fdd01"
    sha256 cellar: :any,                 arm64_ventura: "860830590eea77530bf41bf5033ac337a510bc0e744793444f10fdab26b634e5"
    sha256 cellar: :any,                 sonoma:        "7f0e64fcab274deef8bc7c5670d3ff54d5ee7f777a6ccb5f588c9e807565dad7"
    sha256 cellar: :any,                 ventura:       "14f3d2a88b38dd14ddfc5f8c48e86a2998bded78424860479b41fb6d36b5d9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "776ba0ea484e29191e6e455853c2f17459b680b2b8c825c254f091a52394d287"
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