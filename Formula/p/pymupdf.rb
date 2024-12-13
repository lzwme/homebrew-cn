class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesc38876c076c152be6d29a792defc3b3bff73de7f690e55f978b66adf6dbb8a1apymupdf-1.25.1.tar.gz"
  sha256 "6725bec0f37c2380d926f792c262693c926af7cc1aa5aa2b8207e771867f015a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be92d5188177ced0d861b266c170c8ab7ce173abf42e08caa13c1f3ba9a27781"
    sha256 cellar: :any,                 arm64_sonoma:  "fe6def3f2d051dfdc0907a07bccd1c8742d57f2fe4eeb930163f137c02a6db4c"
    sha256 cellar: :any,                 arm64_ventura: "5417f1b35048cce7e5c2c057357342605f03dd2e0a63d6f88ae9817824ee4e56"
    sha256 cellar: :any,                 sonoma:        "bae7122e5d37c38b3de1a7a72325c9ecb84c700861e77e4ff3b30e788683669f"
    sha256 cellar: :any,                 ventura:       "400da05009236699d49d1450c7810fe07df70b3fe3aa77061b8318280cea9f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a82fba95aeb56cbb6b32bb647f2e02e55aaeed394f2a25276c9818567b97a46f"
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