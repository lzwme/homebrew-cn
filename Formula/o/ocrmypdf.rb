class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/73/57/be84640ccdb9edbd75a86dc05872f446d25d368a109e27312c6b8036a108/ocrmypdf-15.4.1.tar.gz"
  sha256 "a96658efa5d5321c9a5f7bc95980c79c3822583b96874bdf23916196d380b9d2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2f2ba0b1a61bc7745460e9b79fb1ad6311ef16a84bfeaded31f76f9116af66f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d34dda6a1e608d9c7cfc159d99fa6eb7136dc93b78cfdf24fa45658b9b1077d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d4afd3c044bbc4d4f3b0d71a6caa80f1da4e68ccd3ed1bd8a7dbb4308e3593"
    sha256 cellar: :any_skip_relocation, sonoma:         "08e274a0220b726379da7578388dd71c11e1edd137c062a4b60e2d5ea96634ca"
    sha256 cellar: :any_skip_relocation, ventura:        "9214ee4d894396b9efdb4e9d964cd30223d3935a4cdfeeb900d85863a0b6b6f9"
    sha256 cellar: :any_skip_relocation, monterey:       "c8de7c83c3571a2478a9c548aaa8cd688d34d46223417f2fe009544daecf9a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a79c06c4437abf2615953904eed97a9260e2b905a4383295b7016aaecbd4f32"
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
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/d8/cf/efb86961f9aed4f95556a15034ee66b1315de6752290c33634120ff4fcd1/reportlab-4.0.7.tar.gz"
    sha256 "967c77f00efd918cc231cf8b6d8f4e477dc973b5c16557e3bd18dfaeb5a70234"
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