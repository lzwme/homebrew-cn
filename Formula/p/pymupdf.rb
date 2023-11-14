class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://github.com/pymupdf/PyMuPDF"
  url "https://files.pythonhosted.org/packages/3a/75/743a7b990a56eaf4a870f0c6eb7ccd80a9ece040d56c89b851caba49cce0/PyMuPDF-1.23.6.tar.gz"
  sha256 "618b8e884190ac1cca9df1c637f87669d2d532d421d4ee7e4763c848dc4f3a1e"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a4ed1e9603c362b28b4917d33bebe7a638fff2e09ed4d6fadf7781ffedaec2d"
    sha256 cellar: :any,                 arm64_ventura:  "0359a6568c792880e48c64a3fa3f0c2747fd686c5b148b2856a4227ece118fd4"
    sha256 cellar: :any,                 arm64_monterey: "9def3e55b5125d93739d8759af0f74f844fad164c3c79caf6be15be357339ef1"
    sha256 cellar: :any,                 sonoma:         "f45afd2f47867cef5ddad9207254d6fd704492310630b9808edb54f82825ae83"
    sha256 cellar: :any,                 ventura:        "6caae5579db8db819f29211be36c36f2f27539e1d4ba488b875d0db312cdbc7b"
    sha256 cellar: :any,                 monterey:       "74091ca172a6e4b98034e9fa6f7bdbb3ab9e3509454038074277e4232d775d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9536cc77732f1bb6fac2f019368615737184753012de4eee3487f7b9a9481231"
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