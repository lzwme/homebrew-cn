class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/48/d6/09b28f027b510838559f7748807192149c419b30cb90e6d5f0cf916dc9dc/pymupdf-1.26.7.tar.gz"
  sha256 "71add8bdc8eb1aaa207c69a13400693f06ad9b927bea976f5d5ab9df0bb489c3"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae30339e32b0e43595525bc6af02a9a11605e61b82a24dc3e115051831746e3f"
    sha256 cellar: :any,                 arm64_sequoia: "db7d649f47e86e5edde6534910b5e099731b21e64751d8abe4714bfe16bc7be7"
    sha256 cellar: :any,                 arm64_sonoma:  "920af10820d47d4bfd01116fd5072d85d0126040fb45485dea5c599871c863f6"
    sha256 cellar: :any,                 sonoma:        "4cd418fefb6cb221252f5460439f5f9eaf3b128701616dd4cf01447cd6262756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc5b4683314249b8b7b76bc8f60469b190325c1c1bb1df5e6dd8d18b0dedab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a440b55c63cb8ffa753fc5a00b007368a34f8d5da57e48a0deeb0672b8734098"
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