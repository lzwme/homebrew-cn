class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagescf56e9a4b081c6bedcbab54b9f66005af485c4f8cbbf143f1e42a5e174569c8cPyMuPDF-1.23.20.tar.gz"
  sha256 "30583360f58536d171954723d07c965ae4c489f4485f966cc921f23afbcfbf69"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb2b2baf8a33d8e6e202c695a50d87638369dc24c98fd9d1bdb88f12d3846b8e"
    sha256 cellar: :any,                 arm64_ventura:  "7d4ab598c0eba73cfdb3b5813d5ae64485a310ba0a277b72d28114e27c967d97"
    sha256 cellar: :any,                 arm64_monterey: "34a6282af325e07f3c749f83a1d7fd63998632749c1717fbbd8eb7deec789300"
    sha256 cellar: :any,                 sonoma:         "10750c357df3f5554d38f8d8f96118f2ea385c24dbea69f22e1805958151ccf2"
    sha256 cellar: :any,                 ventura:        "489db68622d5257391678f606c550fc3d5454a657bd6f5e7d8803edd3c50eabe"
    sha256 cellar: :any,                 monterey:       "6a1cab22e1f9ee26868b7fe39c389916d8e484932871e18652c81b880a6c8f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a908550952281579403f224ecfe95ee8d36cd2a8fc1bf3f41a2ce1f6ae50989"
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