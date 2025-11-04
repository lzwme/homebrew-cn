class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8d/9a/e0a4e92a85fc17be7c54afdbb113f0ade2a8bca49856d510e28bd249e462/pymupdf-1.26.5.tar.gz"
  sha256 "8ef335e07f648492df240f2247854d0e7c0467afb9c4dc2376ec30978ec158c3"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db033482073562d13e2b4bbbf6476779d2e150d17f2b9d9084e9b7110e6d1939"
    sha256 cellar: :any,                 arm64_sequoia: "14aa7a312c2171f0d9ceff363aec5899e2842254d0843ab4195c2a916c7ba192"
    sha256 cellar: :any,                 arm64_sonoma:  "21d10fe188a2031adca38586a0776b1dbab6417f9ee243b214e36e3670e97cc8"
    sha256 cellar: :any,                 sonoma:        "d872257471aa20ed916e07355adb84123b91e5bd1c05d9d9f5b59aed5528d257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d899c88a0428e1b29f1e620fa08de7204261bc6c3d3261dc4e0f6f35d7d01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b681ae5897e145b2a231d0a783847e103a7d09a85bc17b843323d9c7731146"
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
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

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