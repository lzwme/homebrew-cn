class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8e/e9/6d6c5d6c0a3551bffd47681a6240caf941727f195b45593cf20ab36f018f/pymupdf-1.28.0.tar.gz"
  sha256 "e53f3567403a92da15caa9e7ae0164327fff48817e9f40175367fb9de524258d"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59343dc279d3a46b7a00567d44157389e315fcf2e6fa641270559a79429dc555"
    sha256 cellar: :any, arm64_sequoia: "95d0a08ef4125d3a2633ce934c0d952132af4ed6b2a842f06d6e10f73ca20ba7"
    sha256 cellar: :any, arm64_sonoma:  "20eaa0fbc1f35d70d26083808f273dab108f835b74405e223d91fc479a0bf9c2"
    sha256 cellar: :any, sonoma:        "117a13f89e4c757d592e71e14dcf6f2eae52246aaa1c1b7d45ebd07d074596b5"
    sha256 cellar: :any, arm64_linux:   "04f03c4302d06dc27d82c7a8b1fc898bc61254e9c1653f57a120404e214778b7"
    sha256 cellar: :any, x86_64_linux:  "eedb88d7fb683068c13b5886419bb66f16d87c92bfe66a3a679e1a2109f7e35f"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.14"

  # Pass the options argument added to `fz_find_table_within_bounds` in mupdf 1.28.1
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/b54b70f2410df7d11f9e68c58fe4e0dcb582756a.patch?full_index=1"
    sha256 "7ce5d2b9f8b38fa9c54b78bdf8aabac758c79056bd4a389bf93fa25f5b110eaa"
    type :backport
    resolves "https://github.com/pymupdf/PyMuPDF/commit/b54b70f2410df7d11f9e68c58fe4e0dcb582756a"
  end

  # Skip the transform now that `pdf_clip_rect` takes fitz coords in mupdf 1.28.1
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/87745b21b512440c7fc02e49037c3ad1c173d414.patch?full_index=1"
    sha256 "db40ae037da6c3f427342478912b1baa2cc10c58d2f9211143e9d26fe14bd2ef"
    type :backport
    resolves "https://github.com/pymupdf/PyMuPDF/commit/87745b21b512440c7fc02e49037c3ad1c173d414"
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