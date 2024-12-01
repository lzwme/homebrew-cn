class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagese06b6bd735144a190d26dcc23f98b4aae0e09b259cc4c87bba266a39b7b91f56PyMuPDF-1.24.14.tar.gz"
  sha256 "0eed9f998525eaf39706dbf2d0cf3162150f0f526e4a36b1748ffa50bde581ae"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64cf0006afd80161e68ef5ce0dcdb871c73151dbdad6f2b6b4d7930e3293a63f"
    sha256 cellar: :any,                 arm64_sonoma:  "e5275dd33e381f0675acc97a48417277abea2ec15442591de5721366adcf6e6c"
    sha256 cellar: :any,                 arm64_ventura: "59bffec7b21dbf9af7fdf773964d2e057ca6e168da1e5687987e65bfdb84fb08"
    sha256 cellar: :any,                 sonoma:        "f5aa9121a4391d6837fbb2fc058f375830d581d270ac86aaf92046cbf95e9eb5"
    sha256 cellar: :any,                 ventura:       "5e091b1a390cde51ef30ec52cb0397b849637b3c2f5fd7cd22cabd50586a0bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56bb281d7031d5b6a3e3896e5b16a9fec93b8c968aa676699b55c3316d23ed7"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  # fix build with mupdf 1.25.0, upstream pr ref, https:github.compymupdfPyMuPDFpull4094
  patch do
    url "https:github.compymupdfPyMuPDFcommit8609db72eb59d95ffa37c05991a0b83220865677.patch?full_index=1"
    sha256 "3582c6ad6dcd5bc476913128fb3e922b6be9b18d6ed51b1fad1e88acd3b0aaa4"
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