class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/6d/d4/70a265e4bcd43e97480ae62da69396ef4507c8f9cfd179005ee731c92a04/pymupdf-1.26.3.tar.gz"
  sha256 "b7d2c3ffa9870e1e4416d18862f5ccd356af5fe337b4511093bbbce2ca73b7e5"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e78c1756ed0faa12cbf9f07c8a0097d611904e551c6a611d43bea193419cd304"
    sha256 cellar: :any,                 arm64_sonoma:  "c57d533044a876f174abe58aa0aa1432628f208cd6be601c5eb70cf03218932b"
    sha256 cellar: :any,                 arm64_ventura: "15f18b50f2d2a48b89094a24226ba572485832927bedba9dc673e1b8bd144b85"
    sha256 cellar: :any,                 sonoma:        "b208383e541c46fd060247651f0bd7d6d165abe3ce3582a6992339e48d346b5e"
    sha256 cellar: :any,                 ventura:       "4e31734f24e27e75fb13f10e7ce93c32f551938608026d198395027766eade7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b9d4e47397f940f7ac5dea1b27779254828bc8f30aacd89cbd7a37e9947cbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba560a067a0f5a8498412d81506f622ac849cc179afb84c516571743bb1da8a"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.13"

  def python3
    "python3.13"
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