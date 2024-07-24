class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages2e30dccf3e5bb35ca217fa64600fc4e2ceffd87576cb1c5f3c367f9cc422fa9aPyMuPDF-1.24.8.tar.gz"
  sha256 "51c522e5824adf2317d17cf397daf9393792087a4ec772214011c11335073d6b"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b74300882e6f26b5a4ac63f56c89add88f2ffcb6a7ac765bef5b5102ac21f2e"
    sha256 cellar: :any,                 arm64_ventura:  "28ba3fb7efd169db0b965823e6d0aaaea4c311bca4e3a8ba2c6c84ef54199eb9"
    sha256 cellar: :any,                 arm64_monterey: "c3b26ec16119deead75f3ad89aebe4cfab397f9cbb84331bd42204800f8db0ff"
    sha256 cellar: :any,                 sonoma:         "f46448ed2fe4a1dd6e30b861eb7a2558cb5bb63ad44e29da3aa824525e317e92"
    sha256 cellar: :any,                 ventura:        "9132be15d434f3a13a0d42e4a38df9d8561f5b064b40ae9d29b96f65fe40ef97"
    sha256 cellar: :any,                 monterey:       "a4cf601bef80e64672715427958e9dd88bede83967e6f5fb90644708efd9bb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c4e4c06d04921b4e0458e254ad7fa3a5a1fa3adccb250450b23003cf789db6"
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
    url "https:files.pythonhosted.orgpackagesf88e0c46a62a02cb5f264957e5ab0315ec5aaa276616f0143084601f48dac9bePyMuPDFb-1.24.8.tar.gz"
    sha256 "fd18b791be7632bccd3fb9138bb2f732db4ca0f06ebb92eec5c8ec9f52836c74"
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