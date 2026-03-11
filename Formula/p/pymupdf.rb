class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a4/fb/d80374ab091ab7ad5a5e7981a45c877ae094db668c1ab4d30f1109a4ec6a/pymupdf-1.27.2.tar.gz"
  sha256 "37fc9cedeafb40839f86a074d4d9feab725144bdd4bbfd20308ff8957e2b10af"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e87878adcd25a30c6dd07ce3ed27489dcf49bb382fcfd4734c758e21ce31e2d6"
    sha256 cellar: :any,                 arm64_sequoia: "60435a4448cee4fdbf7cd27d7ab98cad22d501a199556e3ca0bfc7b026c4dfec"
    sha256 cellar: :any,                 arm64_sonoma:  "16c98a4efe380a2cca29e35692ac9d07776e98c38c280d4790160af4035470f2"
    sha256 cellar: :any,                 sonoma:        "ced7fd64af053b3b7345b4ff8f271cad4ce95d74656b9b0a4c30b546ff4de764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825e3b69a8fb03f59e2b4ce3daaae0939d8d2e475b4043eaae415957e9b66ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44f4139ea7ae206990e9d1dd6e5e2697c4e4c8c5c853f999cbf9600ef198f59"
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