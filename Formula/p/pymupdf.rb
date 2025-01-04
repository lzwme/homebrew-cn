class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesc38876c076c152be6d29a792defc3b3bff73de7f690e55f978b66adf6dbb8a1apymupdf-1.25.1.tar.gz"
  sha256 "6725bec0f37c2380d926f792c262693c926af7cc1aa5aa2b8207e771867f015a"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0a0d6d5d52c2df6d185d17f4f9d1388771e9f0e3f68ec57265018c2af66c1da"
    sha256 cellar: :any,                 arm64_sonoma:  "4275efa7ba73aa82f58c3cd10dee0e385ef84a68364440c082c11c2b6a72ed48"
    sha256 cellar: :any,                 arm64_ventura: "22565e2b266cdff2d7f5c366104fd5a0152af4b1c5adcdebda487327ac61ca18"
    sha256 cellar: :any,                 sonoma:        "77877a7112734587723dde759a92455c9699ea03c41b117ec8ea73ee43ade710"
    sha256 cellar: :any,                 ventura:       "26437e1a692e91124e889971cb3644169672045f06b060bf6f0995af3a283a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f328e77395128b0e5c984fdcfec59f5fd29316d7c479a6e77cc71d60b3a0d3fb"
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
    # https:github.compymupdfPyMuPDFblob1.20.0setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{Formula["mupdf"].opt_include}:#{Formula["freetype"].opt_include}freetype2"
    ENV["PYMUPDF_MUPDF_LIB"] = Formula["mupdf"].opt_lib.to_s

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath"test.py").write <<~PYTHON
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
    out_png = testpath"test.png"

    system python3, testpath"test.py", in_pdf, out_png
    assert_predicate out_png, :exist?
  end
end