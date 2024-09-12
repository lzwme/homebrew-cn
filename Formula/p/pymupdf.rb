class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages8357da06ca4886afc71a624e4b463d05f45c8a822596ede939957295e229eb4ePyMuPDF-1.24.10.tar.gz"
  sha256 "bd3ebd6d3fb8a845582098362f885bfb0a31ae4272587efc2c55c5e29fe7327a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d3944baf2837069f2635e037eb0a62f9bc4f6c04462e1e2376fd1db01311d10c"
    sha256 cellar: :any,                 arm64_sonoma:   "e1b5f5455637d64c75b558e9e85052293366952c85ca56ed746ef4e8abe720b3"
    sha256 cellar: :any,                 arm64_ventura:  "618f3b859a59c791a8d10395bfa7e66d1249db7174efb947d79250b98233c05b"
    sha256 cellar: :any,                 arm64_monterey: "d66a781b93de8d4ac97f03071a6fb137918e339905324b6f501458c06b39e5ad"
    sha256 cellar: :any,                 sonoma:         "af4b3796d7b489c3258f58fdefc3a7a6330c56fd51964830da7a93594f8a8404"
    sha256 cellar: :any,                 ventura:        "f88a8026d21772b86bcc3368198cb92b16a9900902bba3550ec498fd67c57fa5"
    sha256 cellar: :any,                 monterey:       "556cb34597a1ee438f1c2d52cba7760f91b0bb4d25baf7b638b364d4dde64245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d67221d0467cef13476e0661e269ea2231fe56234b6cf53cbafbfc7c5b1bd7"
  end

  depends_on "freetype" => :build
  depends_on "python-setuptools" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "pymupdfb" do
    url "https:files.pythonhosted.orgpackagesc9ffecfcb41414b51976974d74c8e35fef0a0e5b47c7046a11c860553f5dccf0PyMuPDFb-1.24.10.tar.gz"
    sha256 "007b91fa9b528c5c0eecea2e49c486ac02e878274f9e31522bdd948adc5f8327"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https:github.compymupdfPyMuPDFblob1.20.0setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"test.py").write <<~EOS
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
    out_png = testpath"test.png"

    system python3, testpath"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end