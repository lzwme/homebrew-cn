class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/23/5d/57297eeb9b56afdf280b97b29e8a98a5484ca843faec8a570923dbde2156/ocrmypdf-15.3.1.tar.gz"
  sha256 "88fa1e422a6f77fc56440ec5e3cc3bd561156b6d7afbc210cf7d701558405350"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07a53a8a669998098571b56b7b81576f58d0ae8e83763541e8c04153d90cf579"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcd51d285be0fc6b622705e47cad7a9a3b11a0d72245db15ff6bb98f0eff7f26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23b6f6d5fe7c2d1e96e9c967adcc35f0341133f2b10ee2d091920ec5ea07c95"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0334a8604a5b6674766ad1898032191d0900308cf16830f3cfd4ae0359bd302"
    sha256 cellar: :any_skip_relocation, ventura:        "70db08a2d9520753722de1a30baa85672c4bd2c5a2377c903317154d2a45d54c"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d64a2ae21c145bd08bae9b6f9b0537642748a5adac0e2b96d122a2a6fd2880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3581f5aa3eef72990dc6cf60e68bfa356bc07dfbae491d6e145ad302588b39fc"
  end

  depends_on "cffi"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/ac/6e/89c532d108e362cbaf76fdb972e7a5e85723c225f08e1646fb86878d4f7f/pdfminer.six-20221105.tar.gz"
    sha256 "8448ab7b939d18b64820478ecac5394f482d7a79f5f7eaa7703c6c959c175e1d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/74/dd/5931d75069458bd39d921fcb157061e9436e169a2e3c47ad9f15cf37f52d/reportlab-4.0.6.tar.gz"
    sha256 "069aa35da7c882921f419f6e26327e14dac1d9d0adeb40b584cdadd974d99fc0"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
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

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[img2pdf].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end