class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages38de71f05f98437daea36ab631608e8ea8040f3a00d21567375878871efc2abcPyMuPDF-1.23.16.tar.gz"
  sha256 "e0545a15ba1d8268a1e0af4abcfa352f793e2e3f46942ac6f682bf559de57c1e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9565ba092e2db244459a647658ccc479fdf39cd97f8c2602cf5e36150c0066d4"
    sha256 cellar: :any,                 arm64_ventura:  "f8c8327e671ebfdb4ab4aabbf17cecd4bd691f8d01f7a34c90f735c059e7dd9f"
    sha256 cellar: :any,                 arm64_monterey: "359761cf8baa8c50e2985636d1cdfc782939ea0a725bc145e48f7a82b66d41c6"
    sha256 cellar: :any,                 sonoma:         "7410faf4843799fc4a3bc18fd457d675403bec8e58528d6c6be0405886cf87b0"
    sha256 cellar: :any,                 ventura:        "5dffacb2bbaf4376aa88c37f943181fedc2b56ea4a16fd5fec89f42e21299b0b"
    sha256 cellar: :any,                 monterey:       "2aaf2b94b8be9d67c25965fa4850f0c1597784c90381ca0fdcb6f1d068894d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee12a9d539c6acde6ecc6a555c4ea1e445a401007b36038dfe37fdbb6d04309"
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