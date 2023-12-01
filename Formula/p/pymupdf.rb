class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3a/75/743a7b990a56eaf4a870f0c6eb7ccd80a9ece040d56c89b851caba49cce0/PyMuPDF-1.23.6.tar.gz"
  sha256 "618b8e884190ac1cca9df1c637f87669d2d532d421d4ee7e4763c848dc4f3a1e"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3ba9c8d34158989ac87dd4c91b20e1009f5d09b51fa8db8a684752fbd91c417"
    sha256 cellar: :any,                 arm64_ventura:  "5d0f82da8e4a5afa6cae4aad60fd860c1a95a73edab3e472cedebe23d831dc40"
    sha256 cellar: :any,                 arm64_monterey: "2e8e1cb6b6519dcbde640b79dd382116d721c7367f4d15cdf8e5f709815e6bcc"
    sha256 cellar: :any,                 sonoma:         "5453aa9f43ac5b7ec19f77de560b81d0d51fcd345c236a4a8c2e4ef519eb60cd"
    sha256 cellar: :any,                 ventura:        "b1e6b4eaf73cfdd96546efe321c4053d396e63eaf9739f84cb37a56b17e76a62"
    sha256 cellar: :any,                 monterey:       "44e22e2d935e3e01b4610d1c4ba51c76b0624353eae8adac282765b1b6b376c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "400a60a386dd5cc3b90898a6e48745b6ea57746dbbcdf838101a12170dd9c2d2"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build

  depends_on "mupdf"
  depends_on "python@3.12"

  on_linux do
    depends_on "gumbo-parser"
    depends_on "harfbuzz"
    depends_on "jbig2dec"
    depends_on "mujs"
    depends_on "openjpeg"
  end

  def python3
    "python3.12"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https://github.com/pymupdf/PyMuPDF/issues/2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include} -I#{Formula["freetype"].opt_include}/freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
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