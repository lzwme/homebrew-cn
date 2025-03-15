class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages2556d7de0325125621a3d095eb43ce35f2e036cd4c0489ff5e8cae816f1cd8b9pymupdf-1.25.4.tar.gz"
  sha256 "5f189466b68901055a9ddc77dc1c91cba081a60964f0caa6ff5b9b87001a0194"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "577577a9c41c7144e5508be5592878d4a918e37095f3cfa231aa83522575d64e"
    sha256 cellar: :any,                 arm64_sonoma:  "2f748a9135cf227930d16b1e775f525a7ea8895700a7c7e2d35330be9a854e00"
    sha256 cellar: :any,                 arm64_ventura: "c896edd42aa5f00817287207cbb00a804a6cc2ba8fea61f423f61f6fac305b6c"
    sha256 cellar: :any,                 sonoma:        "0e0646ba6040a8e99c6c304075daa969cc669fd83bf1969fe8a0056070f099d2"
    sha256 cellar: :any,                 ventura:       "1f4cf62d245b37b89dc872204f6f4a0270b4c33ca50937cd434be56bde8df8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e30f5c3fb9578b7a8e161eeb5d0f46586bd2ef72f427910033fe73486d0f456"
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
    assert_path_exists out_png
  end
end