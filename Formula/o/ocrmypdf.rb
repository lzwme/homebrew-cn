class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/51/3c/b5b5db9845b158e9e3dffb5f5dc692804bf6608f18f16e81737d10f27ac7/ocrmypdf-17.6.0.tar.gz"
  sha256 "2ae7b09363774f0b4ae786520980e168c4dfafd3c43556dc123db0041c68ed43"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "785f83992eb4f71472fe99634de7d9d8ca5510d1e92165d1e1ddce875bf50b37"
    sha256 cellar: :any, arm64_sequoia: "3e958553ed5ed30ad755370e63cb753dd1cfc8c14119b4d113b84608d2592338"
    sha256 cellar: :any, arm64_sonoma:  "ead4c1c589f6fb64bff5d413a91f7c1f5dc069329cf356fa547a135bd024be2e"
    sha256 cellar: :any, sonoma:        "8e64fbc5d4358ee72ac8f27d0bc59c29d0c2c9348f615e29755332414c3c2d69"
    sha256 cellar: :any, arm64_linux:   "714e2c1d9ee53d304cf567128650788e130a9c8accfc0e031d3591887f51ea5b"
    sha256 cellar: :any, x86_64_linux:  "85b3f087c0cae47c2ba88a0559cba924afce53dd9022aa8b1edc5a59d4f20647"
  end

  depends_on "cmake" => :build # for pikepdf
  depends_on "pkgconf" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "pillow" => :no_linkage
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[cryptography pillow pydantic]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "fonttools" do
    url "https://files.pythonhosted.org/packages/84/69/c97f2c18e0db87d2c7b15da1974dace76ae938f1cfa22e2727a648b7ed43/fonttools-4.63.0.tar.gz"
    sha256 "caeb583deeb5168e694b65cda8b4ee62abedfa66cf88488734466f2366b9c4e0"
  end

  resource "fpdf2" do
    url "https://files.pythonhosted.org/packages/27/f2/72feae0b2827ed38013e4307b14f95bf0b3d124adfef4d38a7d57533f7be/fpdf2-2.8.7.tar.gz"
    sha256 "7060ccee5a9c7ab0a271fb765a36a23639f83ef8996c34e3d46af0a17ede57f9"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
    sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/34/a4/5cec1112009f0439a5ca6afa8ace321f0ab2f48da3255b7a1c8953014670/pdfminer_six-20260107.tar.gz"
    sha256 "96bfd431e3577a55a0efd25676968ca4ce8fd5b53f14565f85716ff363889602"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/6a/a2/70168b601b41bdf5726dfc8dc110eb4052a2e851fed9c9bdae95910e401d/pi_heif-1.4.0.tar.gz"
    sha256 "e1199d9d41d9ecc877cf3ae7322ff099f6404574f2e62da47590cd4ecb9ec554"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/77/84/14c5c5cc211ac62356ae02db664153cec7d64440c1fe13d1d40247aa69f7/pikepdf-10.8.0.tar.gz"
    sha256 "295259723a2b464942bc092acee854bb389dd6b520cd853590e4ca89f47bbf41"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pypdfium2" do
    url "https://files.pythonhosted.org/packages/b0/98/6b44bf82ddb3c7a3e0249203772aad8981b4491d6227f182685f310faeff/pypdfium2-5.9.0.tar.gz"
    sha256 "db1274bd27844db6fda17ef1dbcd0026c47d357437058d838e98060c0da9e92e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "uharfbuzz" do
    url "https://files.pythonhosted.org/packages/0c/2d/25769d2262cafcea748aac7bfb2b9eeb0a9fe2a759b4154133a6d9f39870/uharfbuzz-0.55.0.tar.gz"
    sha256 "a29bda4c147c35240a71051315423b1933b46eac558a72f55d9ffdc1f2bbb69f"
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