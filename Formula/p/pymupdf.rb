class Pymupdf < Formula
  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https:pymupdf.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesbd62d29612ca33b7844e77d2c789fec359f4c44fd84bdd08ce673f6279d257e9pymupdf-1.26.1.tar.gz"
  sha256 "372c77c831f82090ce7a6e4de284ca7c5a78220f63038bb28c5d9b279cd7f4d9"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79311d8e2d060eb2e2c42a158f65d24559545a8e97d043a13ae3f0c683513488"
    sha256 cellar: :any,                 arm64_sonoma:  "48a51ebad5a15a778f3d158a38584bc8cf9a8591143d56c903da935679394fd0"
    sha256 cellar: :any,                 arm64_ventura: "a1bb1eb3dc04fe1464e2ad46fdb87274c56c05300ecab8bb1b527c8381e10c9d"
    sha256 cellar: :any,                 sonoma:        "8f675bfda9d7b18b0b607335918c98ba3e219db51aabc50e558f383fe06b9310"
    sha256 cellar: :any,                 ventura:       "69c77096d6b87029f1054fa17f87b3b9473803b063df2f95bb617c1fcd6fa459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9dd77457f5eddf7fdcd1bff1f50d9a0b5b07ab85d42392d98d09280f040f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431a3fa83b570f8b1792cf2907b4be2c6a3bcde584597dc1ff9c216d02f3f915"
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