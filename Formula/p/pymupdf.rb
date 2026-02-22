class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1b/0c/40dda0cc4bd2220a2ef75f8c53dd7d8ed1e29681fcb3df75db6ee9677a7e/pymupdf-1.27.1.tar.gz"
  sha256 "4afbde0769c336717a149ab0de3330dcb75378f795c1a8c5af55c1a628b17d55"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "acad5b7f5a4e3c1df83bca955a281aa395470c78c6e3e53091f97e96f3367c48"
    sha256 cellar: :any,                 arm64_sequoia: "b2d139168b96a7fa1518baa923c3d6283cd4ea93e35df58cddd5ad674db779e6"
    sha256 cellar: :any,                 arm64_sonoma:  "7e108eca9cf88df0771d698cf54cbe61742b5ee18ffa6b774c199b1e0a14bd48"
    sha256 cellar: :any,                 sonoma:        "9e454a704d14a3d123cc123bbd756a1a608e89d3e074fcc9b1ea2e3c797a8365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "471d590a246127266aa862df82580ea51cff2cda8904c20afbf59c1c86d23827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027cb3becedb7ad42e9a51842aa8dc8fda1c62abe0eb130dd997f7b23ecc882f"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}/freetype2"

    mupdf_libpath = Formula["mupdf"].opt_lib.to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.py").write <<~PYTHON
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
    out_png = testpath/"test.png"

    system python3, testpath/"test.py", in_pdf, out_png
    assert_path_exists out_png
  end
end