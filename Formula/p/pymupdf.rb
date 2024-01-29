class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages75960737eec14937013f3f4ad075af76985d2225a79d6c3ce89cacabd1600f7bPyMuPDF-1.23.19.tar.gz"
  sha256 "314b3da25c00a8e9a8db673665b2bf4fe40d02d460449bed7a3b94d5cf2aef92"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8afcbf05b9d9d768f224116e78f395a7fa471a3e7dc3febb848f72f3354e72b8"
    sha256 cellar: :any,                 arm64_ventura:  "103ac2aec0d8734649e5619d35970da4d8254e5520ecce654fb7dcc236d0b588"
    sha256 cellar: :any,                 arm64_monterey: "9e48067b62853b3d5a224e1b758f7bd095ceb521b53157abb85a7a4f8e97de22"
    sha256 cellar: :any,                 sonoma:         "8157916a7401dee39b042ad94ed027211e57af0e5f6dbc00e8f2dece958526ff"
    sha256 cellar: :any,                 ventura:        "d8978d0950095dd0bf0b375288b43d22f505b7f825d5799dc71056133f888007"
    sha256 cellar: :any,                 monterey:       "ee4e1695e33d080cded2cfc376c7ed88422b7ec1e2c6edc8cd3dd828f719279a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130e3a7cc70e6d3e2ea323c8df334606948f3f1a72b14477b6f60dcdbfd99023"
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