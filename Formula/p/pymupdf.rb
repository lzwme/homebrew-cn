class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages6652c87b39831b8989e251464b0db4bbae39a1238829152d863ef224882fdd0ePyMuPDF-1.24.7.tar.gz"
  sha256 "a34ceae204f215bad51f49dd43987116c6a6269fc03d8770224f7067013b59b8"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2a3f10e5baae3d875abdca306dee174005678b2c434bda91d078397c23a8750"
    sha256 cellar: :any,                 arm64_ventura:  "5c0d8476de88622f4f1b4e841906c3baa522c36b35324bba95fa20f1678bbfd8"
    sha256 cellar: :any,                 arm64_monterey: "202d9bb9f63fa2eb13791ca51e846990f341b1b0294dc481faf054d480c4f999"
    sha256 cellar: :any,                 sonoma:         "179e01413aaebf796430cc0299de30c50d16545cfb073267ac929eb9971b4b4c"
    sha256 cellar: :any,                 ventura:        "d421f7d12aef093e46dbefe77d0b304804edbe7430d34811370141c96ee31730"
    sha256 cellar: :any,                 monterey:       "ea29f5bd2fed27fb2f3ee3a8381763c598a5661417071966a1ab26e87b56f1c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e772d9e5fdb3c3ff90253c4a89546200b0a7a828aa9d69f5155658ae52da1c96"
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
    url "https:files.pythonhosted.orgpackagesbc5dca7ef871a342710142805fab3992bb32befce94bed29e7f38d38d0748f25PyMuPDFb-1.24.6.tar.gz"
    sha256 "f5a40b1732d65a1e519916d698858b9ce7473e23edf9001ddd085c5293d59d30"
  end

  def install
    # Makes setup skip build stage for mupdf
    # https:github.compymupdfPyMuPDFblob1.20.0setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    # Builds only classic implementation
    # https:github.compymupdfPyMuPDFissues2628
    ENV["PYMUPDF_SETUP_IMPLEMENTATIONS"] = "a"
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}freetype2"
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