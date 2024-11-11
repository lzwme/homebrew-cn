class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/67/d0/d7650b5354855943fc6c4779a3448d5cb3279dd5f59ff45d0092e9213959/ocrmypdf-16.6.1.tar.gz"
  sha256 "c5c86223aa7f860734ce5db84975bbca223251357e1a6160291ff64019aee185"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5cfa9e111ca5b8adb7419098f61fdfab042b82ca15e203e2c7cd7671e61c274e"
    sha256 cellar: :any,                 arm64_sonoma:  "d78f1f03b6bf0d20afd32dea91f90e477019714e79822651293188a22474e569"
    sha256 cellar: :any,                 arm64_ventura: "9bfdc0b05429094afa289622b67c014cbad76028f05cbecbfc61bf56c8c9c1d0"
    sha256 cellar: :any,                 sonoma:        "e3a02e27ef4dbad94af2149aedc67dc7c34eda401a4f671fa68c0f9219f01569"
    sha256 cellar: :any,                 ventura:       "1442dbd9e44dc3362b8b028585a40d9853922d27a337246e2c79a556fcbfccec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2d9f3f58100f55c775d2fbe9ee72ba1fcc5d033d9aa1052cf116d2510b65f5"
  end

  depends_on "pkg-config" => :build
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

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
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
    url "https://files.pythonhosted.org/packages/5e/97/41dd02b235d3a761dcbf56993bca96f54e8e7e114d4c75761408d15ceb89/pi_heif-0.20.0.tar.gz"
    sha256 "f63b5ab190697c91dec482112bfa90751e48070899f4888317e943075dccf0be"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/4d/26/c74b0a08bdb743983e4ab65d7294a4e0e0d33fc03acb9802cd9a719414b8/pikepdf-9.4.0.tar.gz"
    sha256 "1f1f53368c8a25f8c5e96dc19e57c0ad3d8bd7f259ca730ac5b0bd9d21747d5a"
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
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system bin/"ocrmypdf", "-f", "-q", "--deskew",
                           test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end