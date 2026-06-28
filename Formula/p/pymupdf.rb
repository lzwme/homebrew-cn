class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/22/32/708bedc9dde7b328d45abbc076091769d44f2f24ad151ad92d56a6ec142b/pymupdf-1.27.2.3.tar.gz"
  sha256 "7a92faa25129e8bbec5e50eeb9214f187665428c31b05c4ef6e36c58c0b1c6d2"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d07a2e9796714723c19a2d7c769fd5c9e3510db9557dc1e1c679ae1d07a3578"
    sha256 cellar: :any, arm64_sequoia: "cc819a128442c3aae8e876063c8c15e6f731e40161754197e707202e51624efe"
    sha256 cellar: :any, arm64_sonoma:  "63ceb0a5df32cb2d4f9238605f591e9ddf7a801db9f9129b46fc6f385dff2fa1"
    sha256 cellar: :any, sonoma:        "ca52b86d12496c9c4f627f317c5c176e0a76bd4b19087acbdcf5935b017d432f"
    sha256 cellar: :any, arm64_linux:   "a2356f67c921a53e27bfc633d99358243aa649ce0a39a5ec9df996907cffd75e"
    sha256 cellar: :any, x86_64_linux:  "146a675fae5eba7bfab23ce7b3274599788b3defca7a741f0440dee57e9d341f"
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