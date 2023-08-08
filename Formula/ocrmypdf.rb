class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/f7/1a/d8205c672ac5d3b855a2e7eba2f7780513a7d9ce75164116faac69b33be7/ocrmypdf-14.3.0.tar.gz"
  sha256 "faa221f53771a6679ad541307a0e66e11d298a33a2840cf1908a6a46f8315ede"
  license "MPL-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ca100e192138f9381b576f7afe888e3d5cbbd15ea5b427b56f38a8502fe13c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72c89f0c6b07a11e20b773aeaba63fbd066a524adf6fc904eb6ebd0b34d93874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63076a1580793d7e9be38bfb79e241bead270f9b0b5c640f9f41e9fd248c11bf"
    sha256 cellar: :any_skip_relocation, ventura:        "0f893ebf7bd5464a6cd9af7c7f86c7d036e98dc810e54ef85a0defc859d97bb2"
    sha256 cellar: :any_skip_relocation, monterey:       "35959e409effbf3a3b3b330f652b5e23d21ee1d686e5fe9b8c04cff1c56c50b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4330af3bdf59ed7c93a76f66874a99b771448e7db7cf90744f3d5cdb3ac53582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00aadc14f7b055c46a4605cbef8959c766fec9a6eb3e4c16f51921cdafbd526"
  end

  depends_on "cffi"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/95/b5/f933f482a811fb9a7b3707f60e28f2925fed84726e5a6283ba07fdd54f49/img2pdf-0.4.4.tar.gz"
    sha256 "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/ac/6e/89c532d108e362cbaf76fdb972e7a5e85723c225f08e1646fb86878d4f7f/pdfminer.six-20221105.tar.gz"
    sha256 "8448ab7b939d18b64820478ecac5394f482d7a79f5f7eaa7703c6c959c175e1d"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/d0/a3/b4951d002af6fc1fc6a938ce48f82c0561f18bbcb4fca64910b01c801bf2/pikepdf-8.2.3.tar.gz"
    sha256 "77dc52bc0064af10abce890bc0e2496d57ba766e0946a5ac8701a853b00f3403"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/67/5f/096c281d19b10b68f6bbf3f1b773c8f83aa94c4aa2e0c8f07e9921fb2cdb/reportlab-4.0.4.tar.gz"
    sha256 "7f70b3b56aff5f11cb4136c51a0f5a56fe6e4c8fbbac7b903076db99a8ef31c1"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    resource("reportlab").stage do
      (Pathname.pwd/"local-setup.cfg").write <<~EOS
        [FREETYPE_PATHS]
        lib=#{Formula["freetype"].opt_lib}
        inc=#{Formula["freetype"].opt_include}
      EOS
      venv.pip_install Pathname.pwd
    end
    venv.pip_install resources.reject { |r| r.name == "reportlab" }
    venv.pip_install_and_link buildpath

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end