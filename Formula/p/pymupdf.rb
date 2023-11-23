class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3a/75/743a7b990a56eaf4a870f0c6eb7ccd80a9ece040d56c89b851caba49cce0/PyMuPDF-1.23.6.tar.gz"
  sha256 "618b8e884190ac1cca9df1c637f87669d2d532d421d4ee7e4763c848dc4f3a1e"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d960bf6c4c44383b2384b05d83af5a59870f9f5d1055e55409ca43f2d44a8cb7"
    sha256 cellar: :any,                 arm64_ventura:  "04a8d1da6863cc11a3abd6749da6bae2f611d5749f555c5cd3b9eed9c039b96a"
    sha256 cellar: :any,                 arm64_monterey: "ce4e194518769101c236fbcaff9c67c412c968a5f98e6484f284d971a0691d99"
    sha256 cellar: :any,                 sonoma:         "a3d83003a4b50ee1af6f490a0fef8eae343bf3b0fb84c34d82cda657367db88f"
    sha256 cellar: :any,                 ventura:        "c86fe580e328b1286957a168c8ce6932007d28e0d3bebd1d3f9c5b3034410be2"
    sha256 cellar: :any,                 monterey:       "e3d34f70981127d269bcb3a96370689175de5b2aa3a027ca246f512e00c01434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9570919bc5c86474600b6075c8811913c316b420af4eeda0909c43718197e77"
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