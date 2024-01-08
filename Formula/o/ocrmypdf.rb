class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/03/3a/2b59b328937dbfd7e1db04d6907ad6d1d0a64cc8c980607579b6a4048be4/ocrmypdf-16.0.4.tar.gz"
  sha256 "beddf3156af9057e828004c5054dcc048a22dff4a02628558f3801d9b33fbe54"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f13d453e27a2bf0ca962c0271e65cfdb82e5e0b3b44a800446cae5e8c49a2eb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8df761c8d81ffda2f54b74af03e54780d8804101e65db5a650236563d69a94f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cab135a2e41c2ae88cf1f049f3063fe715e666ef7fb313f1c29f38a67524a148"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a0a77c07662236418270667ac12725bcda806660fe53641f5c89a0337efbcd2"
    sha256 cellar: :any_skip_relocation, ventura:        "b4adb83766d7f8530c479139348d89ac7e66fc069a90a369665ebc2059d86fe7"
    sha256 cellar: :any_skip_relocation, monterey:       "07964150491bab33573e23330ef7e73b959b50454ba9884a16cc72fccf4304a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de72757119f865cb788f61e87b6af9b01c1607ee6bb78666578fa5fc10f04d41"
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

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
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
    url "https://files.pythonhosted.org/packages/31/b1/a43e3bd872ded4deea4f8efc7aff1703fca8c5455d0c06e20506a06a44ff/pdfminer.six-20231228.tar.gz"
    sha256 "6004da3ad1a7a4d45930cb950393df89b068e73be365a6ff64a838d37bcb08c4"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[img2pdf].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system bin/"ocrmypdf", "-f", "-q", "--deskew",
                           test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end