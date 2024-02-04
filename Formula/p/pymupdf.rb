class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages659d3e9ef1ed83d9cb876d37a2b312803a26137cb619d38fca9ac296ce305834PyMuPDF-1.23.21.tar.gz"
  sha256 "79539ff09c5b7f8091bea3a9d48cd2490c1a14a3733589f280a4f48c51582c4c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f694672276dc1a118fd2d7c58005ff99b7751f4cea572dce78fa4fee9bf644d"
    sha256 cellar: :any,                 arm64_ventura:  "8ae197158164921f54484156364a15b4f8e196cbee91d9fc712e62a7b02ad72d"
    sha256 cellar: :any,                 arm64_monterey: "23790fec0dc1bc8f766677af0f6398f81e2d1064b6d214fa7162241f452fcec5"
    sha256 cellar: :any,                 sonoma:         "a6f3bbfea867adc00070ac9abdf94e41b1a71b5b06cb622eba73288abf059dec"
    sha256 cellar: :any,                 ventura:        "805110b652d1c91c63800d9597994c0bac5cd16b553a252160447a84936918c3"
    sha256 cellar: :any,                 monterey:       "14f5e2dc18d1796d0404be17a5db8b86e2cde7b6c74d0c57174cf8e3293f616d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20358f9f6461deaf1bbf90c545e93d323297ab529e42163ad5c858e01f6333eb"
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
    # https:github.compymupdfPyMuPDFblob1.20.0setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https:github.compymupdfPyMuPDFissues2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include} -I#{Formula["freetype"].opt_include}freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"test.py").write <<~EOS
      import sys
      from pathlib import Path

      # per 1.23.9 release, `fitz` module got renamed to `fitz_old`
      import fitz_old as fitz

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