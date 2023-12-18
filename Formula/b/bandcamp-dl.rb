class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https:github.comiheanyibandcamp-dl"
  url "https:files.pythonhosted.orgpackagescb6f08d0e2b1819327e375ebf67af0689727b2d49db7c0d11d4829552ea01ae4bandcamp-downloader-0.0.13.tar.gz"
  sha256 "c7dbf489b2611406148a6ced25e5814b1fe666e3b3da6c744cfc3df2abe1b270"
  license "Unlicense"
  revision 4
  head "https:github.comiheanyibandcamp-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fcde9cbd092bbad26f8d217a508ddee3907f5c90545b094b98f4e693df75307"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa649557058cc3cf1d12cb9b059f699a54e0c3321fa469c1f6d34a3e4fa345d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f1891b49ffafe195d12d5122d5bc73ebbd9e12b772e17d137a32ee8e68ec611"
    sha256 cellar: :any_skip_relocation, sonoma:         "7afb83cf20cc18dec43813a98a3169c6c6ef1e0f2830f2088059787ab4be1ab5"
    sha256 cellar: :any_skip_relocation, ventura:        "30f1ea2d685a26846d480de0fd55df87701064374e3bc3a013fe31259f4ea66c"
    sha256 cellar: :any_skip_relocation, monterey:       "1c6795cde3185c60e38b764916aac626a32a950b394aee905070a85dfd1c1f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d38d6d36d2c3e8f70aab556499389eb05f010c8265fc99031523e9df66bd00f"
  end

  depends_on "python-certifi"
  depends_on "python-docopt"
  depends_on "python-lxml"
  depends_on "python-mutagen"
  depends_on "python@3.12"
  depends_on "six"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "demjson3" do
    url "https:files.pythonhosted.orgpackagesf7d26a81a9b5311d50542e11218b470dafd8adbaf1b3e51fc1fddd8a57eed691demjson3-3.0.6.tar.gz"
    sha256 "37c83b0c6eb08d25defc88df0a2a4875d58a7809a9650bd6eee7afd8053cdbac"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "mock" do
    url "https:files.pythonhosted.orgpackages66ab41d09a46985ead5839d8be987acda54b5bb93f713b3969cc0be4f81c455bmock-5.1.0.tar.gz"
    sha256 "5e96aad5ccda4718e0a229ed94b2024df75cc2d55575ba5762d31f5767b8767d"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "unicode-slugify" do
    url "https:files.pythonhosted.orgpackagesed37c82a28893c7bfd881c011cbebf777d2a61f129409d83775f835f70e02c20unicode-slugify-0.1.5.tar.gz"
    sha256 "25f424258317e4cb41093e2953374b3af1f23097297664731cdb3ae46f6bd6c3"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackages805df156f6a7254ecc0549de0eb75f786d2df724c0310b97c825383517d2c98dUnidecode-1.3.7.tar.gz"
    sha256 "3c90b4662aa0de0cb591884b934ead8d2225f1800d8da675a7750cbc3bd94610"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"bandcamp-dl", "--artist=iamsleepless", "--album=rivulets"
    assert_predicate testpath"iamsleeplessrivulets01 - rivulets.mp3", :exist?
    system bin"bandcamp-dl", "https:iamsleepless.bandcamp.comtrackunder-the-glass-dome"
    assert_predicate testpath"iamsleeplessunder-the-glass-domeSingle - under-the-glass-dome.mp3", :exist?
  end
end