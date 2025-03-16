class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages2556d7de0325125621a3d095eb43ce35f2e036cd4c0489ff5e8cae816f1cd8b9pymupdf-1.25.4.tar.gz"
  sha256 "5f189466b68901055a9ddc77dc1c91cba081a60964f0caa6ff5b9b87001a0194"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5a381c87e396589fe0c662f7d6685ddf7e638579cd3044042cacc34995e276d"
    sha256 cellar: :any,                 arm64_sonoma:  "e3ce4888dde60bb562090c9f6f614d870b967cea603255dfc57a81a071270039"
    sha256 cellar: :any,                 arm64_ventura: "50e10c16674d2c92071eea04ada93da90f2f2ba6d32f14cee358296dc0f9a82f"
    sha256 cellar: :any,                 sonoma:        "a91cf397e808424e82f09bfcad669be8826c553894e3d34919fa1782bcaf1f58"
    sha256 cellar: :any,                 ventura:       "ecfa9d74ca9898b631b22729ebd7fc4014e81f066e6fdf3fcbe8e3b68c8eef90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c311790aaf4d69cca825018d90ad0bccb01557e0b8c84eea5b9f423e01b10069"
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