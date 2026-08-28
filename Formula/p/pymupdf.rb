class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a3/fb/b6761fa2d5266f2cdb24c3b91f4023070ab7848381417678e7a289a1d52a/pymupdf-1.28.2.tar.gz"
  sha256 "5e0be7908a715aa20333caddd73f1d6f01e4cd0c26e869fa2dd0b7f344da2249"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5260262e08cfd6d674ace486ae8cbe1fe5db97077ac74f50dbfdb6c6153f72ff"
    sha256 cellar: :any, arm64_sequoia: "ec6262a6e9aa0e00fb1eb5cab005b89fb6798e44a2820cb099dee93bed1b559f"
    sha256 cellar: :any, arm64_sonoma:  "766d93639ef0d2781a12c4fa8e2918d5eb6127edf8ddeeb066b3f55b635f8793"
    sha256 cellar: :any, sonoma:        "201f138705f8095a2b5566b842fcdefa7df3f8619f8c34b46a165d1979439682"
    sha256 cellar: :any, arm64_linux:   "68793c9b05f9c765769a0300d28a81eb4b76f68bcc5d86971899e2c9157425b8"
    sha256 cellar: :any, x86_64_linux:  "3221af08dfd35f3b6e697aa0eefa404349c289494095350875e8e85b2edd732d"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  # Stop using the Python 2 C API macros that swig 4.5 no longer defines
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/7f419a5bed7b257416f6837580dc4325e240e625.patch?full_index=1"
    sha256 "5b809a94ea89bedd215f4424c501c2e0b7800b460a8d1641ac910d88f57ae4bf"
    type :unofficial
    resolves "https://github.com/pymupdf/PyMuPDF/pull/5072"
  end

  def python3
    "python3.14"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{formula_opt_include("mupdf")}:#{formula_opt_include("freetype")}/freetype2"
    ENV["PYMUPDF_SETUP_SWIG"] = formula_opt_bin("swig")/"swig"

    mupdf_libpath = formula_opt_lib("mupdf").to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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