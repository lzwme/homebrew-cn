class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesbd62d29612ca33b7844e77d2c789fec359f4c44fd84bdd08ce673f6279d257e9pymupdf-1.26.1.tar.gz"
  sha256 "372c77c831f82090ce7a6e4de284ca7c5a78220f63038bb28c5d9b279cd7f4d9"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e3175387dc83f35a1aaf2f10a467a65bac6ff8366746c7cec3135790b82427e"
    sha256 cellar: :any,                 arm64_sonoma:  "1f3a2dc84f32e86be9e963beb2e4e753c9bf440e758c102a1061f3701c1df1fd"
    sha256 cellar: :any,                 arm64_ventura: "c5474149290b87844056a131a579e3fba1f3a5057cb21143e8c8a7fbf607aeb7"
    sha256 cellar: :any,                 sonoma:        "b3db5c705fcf60a8fd6c288ad3148d28d4367315b88301e22335bb0737cd6b38"
    sha256 cellar: :any,                 ventura:       "7886b77c9b93eab1eb34d3b998e16e18a753cee5426d07eeaee7c8b6b15679b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb2d1ee09291b482aeaba51fe55f9104c82d08153e80ee702ee9adde389aa98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad5b085e40b190cea6f43455b18401707b30bca95b1534f3d01231cba1f3eea"
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