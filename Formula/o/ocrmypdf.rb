class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0f/82/468a0edf5bd36ef133bbcf71a1d93edfffe13caabf635d79a912f72c6fda/ocrmypdf-16.3.0.tar.gz"
  sha256 "4368213279e9cb6a0ff0364bf20366b7ee903a2d66812266fe7fc2bb429c5938"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fda967ed86934d8716f535bce78e7bd6893444772d7917a74732392763df49e3"
    sha256 cellar: :any,                 arm64_ventura:  "8f497addc0c74e69e74322131f9bb422799c5c3940b7486cf27c76cddbdd56d4"
    sha256 cellar: :any,                 arm64_monterey: "77821756e1b78dfa563100b3f19b72c8b1551ced5e621263cf439cec05742103"
    sha256 cellar: :any,                 sonoma:         "8b1de38e83ef8797de89f1d4235bdfb61d316b95fcf796ed9624983fa3e3f04a"
    sha256 cellar: :any,                 ventura:        "cb7491ff61dfea112cc94ecf07a43c4491f50d736a07946ad9efc50d6b19b76c"
    sha256 cellar: :any,                 monterey:       "b57a79b5eddfede0bec8d49f8affcd7deec7e9bc3d912ac4893090abfa529933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1dc6919e90bbb996c87f4cbd4e884930587fe83ac6ec3d9f511465c241fd1d9"
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
  depends_on "python@3.12"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
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
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/31/b1/a43e3bd872ded4deea4f8efc7aff1703fca8c5455d0c06e20506a06a44ff/pdfminer.six-20231228.tar.gz"
    sha256 "6004da3ad1a7a4d45930cb950393df89b068e73be365a6ff64a838d37bcb08c4"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/92/e5/a674bb9ede3495d64a08ec5ed79847d881fc88ff9c93187d952591d07b91/pi_heif-0.16.0.tar.gz"
    sha256 "53fd0c582b01f1763ffa9959694164424c658eb3af5843f187ec019a0f0ef2b4"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/7c/47/87a19cc2af6e82c00d79e9bcd75d9ce3a964943386f44e441d76d086c674/pikepdf-8.15.1.tar.gz"
    sha256 "653aceedb2b3a4cdb579a55aaf78632b434b7cd53e2557b2bc8c8590bfe1d92b"
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
    url "https://files.pythonhosted.org/packages/b3/01/c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aa/rich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
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