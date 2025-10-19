class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8d/9a/e0a4e92a85fc17be7c54afdbb113f0ade2a8bca49856d510e28bd249e462/pymupdf-1.26.5.tar.gz"
  sha256 "8ef335e07f648492df240f2247854d0e7c0467afb9c4dc2376ec30978ec158c3"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1640400684cc4f1594dd02915c209b704ff97fc1742d69df64bc47c1c24831fb"
    sha256 cellar: :any,                 arm64_sequoia: "59912081b10b4c896ece7f2cd05f51e88fd9854cb4d210249fa5e414ced339b1"
    sha256 cellar: :any,                 arm64_sonoma:  "659c39638924872743460103b9db35b0c16486234fd9a82330bdcd2541a0e08b"
    sha256 cellar: :any,                 sonoma:        "54a156154fbbde2ce17a425d88db0a9021bc60a10dbd8f9171e2cfb7b4e2dd17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a84aa29e16196b5305b46cfedf7955cf102bc423e111df96e36b1533c66db053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23e19f4bce19c994553f6a69c8292b2309795de20aa0666a5bbdb486b295307"
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