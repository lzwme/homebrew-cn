class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages6fb12ab072c90cb0778728e7b93480b89380fcc8777888db8cff500bd4593985PyMuPDF-1.23.15.tar.gz"
  sha256 "54fe0c0e6879922875a8d43ec8f66cc346cbc7ee71fc47d34fe101653cb0661d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "64111787b4ee2e096040351a4e130e9cd5db9cfb0187565691cac41c8c91ee57"
    sha256 cellar: :any,                 arm64_ventura:  "aec521ee1faee230d2842977bd2e6169022396707c4253646de73b17d3a6c68a"
    sha256 cellar: :any,                 arm64_monterey: "671ad4ea29884356d313175b95d38f8771eacaf6390d22e19cee7d39b0f66306"
    sha256 cellar: :any,                 sonoma:         "c0f8980bd5a8b1746f088173f569d435999d005c42b88c1700173dd68608d3ee"
    sha256 cellar: :any,                 ventura:        "b42d9ddc0e8fb0e9c01184cef0dd9dbf070223df40ddfa0c0048023e3f7fcac8"
    sha256 cellar: :any,                 monterey:       "a62d1228e12fdebb03b8566b92e42053dbab53d4de5db19d54f6dd84525a7d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893fafe5fb40da561e86e6d86444de2030201dc190ab2024ff0111d7dedf48ec"
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