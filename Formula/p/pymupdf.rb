class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages223984efca63af4e5a014c1d4c21686469f99c3d1c160a3a0b902ac676f6ffd9PyMuPDF-1.24.13.tar.gz"
  sha256 "6ec3ab3c6d5cba60bfcf58daaa2d1a5b700b0366ce52be666445007351461fa4"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "86748cfce03161ff51973cd05d09bc3a77c1a52cab50f31cfd3867c7a3a5a36b"
    sha256 cellar: :any,                 arm64_sonoma:  "2a9bcd81bc4a34d0bf9a2f4701c615867394312f4ca8b92d29af8afe07c82c80"
    sha256 cellar: :any,                 arm64_ventura: "8b5fe5ce381428df8a3d0f70b8fe61e9db896658aa0df4e549bc619e5c667d4d"
    sha256 cellar: :any,                 sonoma:        "87f452f5c6d8a1851b08b6103c923ecd023182e0f089d4b88242ed9e489c3d16"
    sha256 cellar: :any,                 ventura:       "95968af9f7d6a33c260fcba3ffa8d6da270f4461cfa53579e9008666db1576a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16a775e5611808a9a433472999b5b275dd1ca4a2d7b6d0fbca736a4c3e9f5da5"
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
    (testpath"test.py").write <<~EOS
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
    out_png = testpath"test.png"

    system python3, testpath"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end