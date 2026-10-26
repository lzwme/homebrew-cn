class Pymupdf < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for the PDF toolkit and renderer MuPDF"
  homepage "https://pymupdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b0/23/3575cf6652171bba33fd4b41d34ab92c7ee75bb5e5790f5a2a044b9ba49b/pymupdf-2.0.tar.gz"
  sha256 "7733136f626fffe98677daa53c906eb45f2eb486a6450dbcfd652cbbd760f1e2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b0fed251ae621bc71fa438bbe76335134f1e31cea3fb6603a97b3857a8b4ddd6"
    sha256 cellar: :any, arm64_tahoe:       "1cd5778f6e625ab842e012d3d91b16b49ed4ccff670b80f959ece77151a4641c"
    sha256 cellar: :any, arm64_sequoia:     "c314fa8e603d3729b90a19ec4c4ae4c92ce5381453c64fa7da7177ed4dec4e1c"
    sha256 cellar: :any, arm64_linux:       "d13eb47a04d59a4f6fabf46ae90e4b5413d738418e922d07c8219e9d40e9376b"
    sha256 cellar: :any, x86_64_linux:      "3fc06fa08c0b44e5ee47f743120b891421ad211458dcf1a46a118cd312597619"
  end

  depends_on "freetype" => :build
  depends_on "swig" => :build
  depends_on "mupdf"
  depends_on "python@3.15"

  resource "pipcl" do
    url "https://files.pythonhosted.org/packages/1c/9d/d797318cf82fff625670bbbf88a722d87299c9d8f3fc8372603713ac0af4/pipcl-13.tar.gz"
    sha256 "286aba9785463c83659a565210a82a77896195d3303bff0542e825479b56daf2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  # Fix system MuPDF library paths, upstream PR ref, https://github.com/pymupdf/PyMuPDF/pull/5197
  patch do
    url "https://github.com/pymupdf/PyMuPDF/commit/4b4139e40fa68cd69e20e23c0f6360f818594f83.patch?full_index=1"
    sha256 "5eb995985cdf7a0ca7b09d4652d8b284d4988d2cdc4014ed8dd904fa593f6482"
    type :unofficial
    resolves "https://github.com/pymupdf/PyMuPDF/pull/5197"
  end

  def install
    venv = virtualenv_create(buildpath/"build-deps", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # Makes setup skip build stage for mupdf
    # https://github.com/pymupdf/PyMuPDF/blob/1.20.0/setup.py#L447
    ENV["PYMUPDF_SETUP_MUPDF_BUILD"] = ""
    ENV["PYMUPDF_INCLUDES"] = "#{formula_opt_include("mupdf")}:#{formula_opt_include("freetype")}/freetype2"
    ENV["PYMUPDF_SETUP_SWIG"] = formula_opt_bin("swig")/"swig"

    mupdf_libpath = formula_opt_lib("mupdf").to_s
    ENV["PYMUPDF_MUPDF_LIB"] = mupdf_libpath
    ENV.append "LDFLAGS", "-Wl,-rpath,#{mupdf_libpath}" if OS.mac?

    # The core bindings are built as pymupdf-lite in 2.x, without the optional layout/LLM components.
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