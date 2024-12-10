class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0e/0d/135a35c1be3f50b5cff61360eb28f7965b9c92dd85238f3e9e27db595058/ocrmypdf-16.7.0.tar.gz"
  sha256 "d79c37dc1404931eaa7ee15dc281d9da5575b8f361a55a509962a969d002daa4"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26fae418cf02a7accb78a3392ebb02d9338942d3e49117bbc7c96cb27591a866"
    sha256 cellar: :any,                 arm64_sonoma:  "24de273f664cff91e1dc7a143e7398afa49cb305ee024e5b206c735dd5fef02e"
    sha256 cellar: :any,                 arm64_ventura: "5426373fa590ef1ee09aa7fb688a0aa466c5b19f44a6ec1983ae565216b18213"
    sha256 cellar: :any,                 sonoma:        "03bda81e9849964b205463af38a908f1e4045dd30504c685f5ab874e4709a9c2"
    sha256 cellar: :any,                 ventura:       "79b0766fdc3fc36550f873de65c8f34f3ca58eb0f5fedf5597ee25ec19ab510e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96319ef39b5a9bcccf9a966acbc3496b95e1955f64e1d9bae2961c5457744bb6"
  end

  depends_on "pkgconf" => :build
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.13"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/2e/a3/53e7d78a6850ffdd394d7048a31a6f14e44900adedf190f9a165f6b69439/deprecated-1.2.15.tar.gz"
    sha256 "683e561a90de76239796e6b6feac66b99030d2dd3fcf61ef996330f14bbb9b0d"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
    sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/e3/37/63cb918ffa21412dd5d54e32e190e69bfc340f3d6aa072ad740bec9386bb/pdfminer.six-20240706.tar.gz"
    sha256 "c631a46d5da957a9ffe4460c5dce21e8431dabb615fee5f9f4400603a58d95a6"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/f5/12/e87b1a7e5b353f885b646ee9c966be74b7db0ae9d68abc712411487353d7/pi_heif-0.21.0.tar.gz"
    sha256 "4902cdb84e75505e1d9abdd5aff1e6dcfebe569ec825162d68a4a399a43689a4"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/57/54/71552c3ab2694618741e5579506759238716664400304cb615917a993df5/pikepdf-9.4.2.tar.gz"
    sha256 "0108c063bc56dc2dbfc87f20533a728342a938f4c85e39773866b71255aa8388"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/24/a1/fc03dca9b0432725c2e8cdbf91a349d2194cf03d8523c124faebe581de09/wrapt-1.17.0.tar.gz"
    sha256 "16187aa2317c731170a88ef35e8937ae0f533c402872c1ee5e6d079fcf320801"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system bin/"ocrmypdf", "-f", "-q", "--deskew",
                           test_fixtures("test.pdf"), "ocr.pdf"
    assert_path_exists testpath/"ocr.pdf"
  end
end