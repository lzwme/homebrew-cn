class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesc38876c076c152be6d29a792defc3b3bff73de7f690e55f978b66adf6dbb8a1apymupdf-1.25.1.tar.gz"
  sha256 "6725bec0f37c2380d926f792c262693c926af7cc1aa5aa2b8207e771867f015a"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c912b40170f9ddb7cf758d9404d512e1149433657fc121791758e751a0b4ecc4"
    sha256 cellar: :any,                 arm64_sonoma:  "668843df8fce9964f529d09e6b6c39012a1d0f3e4d927642df2226e34f3d18fd"
    sha256 cellar: :any,                 arm64_ventura: "ac8e8dea534dccce92f51c135f02ce2bbc90950734a7f64727422a0754c18c1c"
    sha256 cellar: :any,                 sonoma:        "a6ef3bcd294317050b62913cb20e6cab863a9328271e86362dfe19d6f50891fe"
    sha256 cellar: :any,                 ventura:       "7e86e9e548a498d8570d7b354a6ec3ead61582bcd6a261ec97c3af4b339878cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730696ec68454ce087a9238710a3729d09a9d4b599dedd7905c9025fc6868e36"
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
    assert_predicate out_png, :exist?
  end
end