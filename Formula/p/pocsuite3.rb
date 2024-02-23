class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https:pocsuite.org"
  url "https:files.pythonhosted.orgpackages0f05b17921332ab312c04ccc67b3d01a0d4318a4d45eb0315531f66d41a89639pocsuite3-2.0.8.tar.gz"
  sha256 "9508ffec49519e5421f19472a582d747b44bf3db289357ed39227e9addfceec3"
  license "GPL-2.0-only"
  head "https:github.comknownsecpocsuite3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c26a3e67eb1e842bee39a4fb12efc9b0b201a464eb1d16c2b83d590e434e431"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b19e1f0902b3111590a5e2045db7908af16c7b7f2128ea33f7f42a9b479acea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d64e346fdc2760080ce2ca10989c93a64d601e5f50e2774d40db02bfd6a9b6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f73aafc4c1f6bf09f0adaf500ccbc21a5620ccf2f14b401063c0cd8efd1a6d7e"
    sha256 cellar: :any_skip_relocation, ventura:        "9b98e284bffa5684187ce3dee1a915e12161474e3c443b401119476ccedd4c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "946a08684ff845aabb927a4228f7a7c3e9f55499fdbe1e3cb00a4de49c19b73b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e917d9185bd4f64fc945a705eb1c40582904391ee8498dcb1241dc7b3e16c11c"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesdb382992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "dacite" do
    url "https:files.pythonhosted.orgpackages6f6df7ee0f5410665cdfbd56d0caf5da9217410348e5a0c11d3e6cfe1c1ddd7adacite-1.8.0.tar.gz"
    sha256 "6257a5e505b61a8cafee7ef3ad08cf32ee9b885718f42395d017e0a9b4c6af65"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackages25147d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bcdocker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "faker" do
    url "https:files.pythonhosted.orgpackagese34ae6d8a070e5eb2528495df3fa88226afd5275dc6af67d81148f6172fe5577Faker-23.2.1.tar.gz"
    sha256 "f07b64d27f67b62c7f0536a72f47813015b3b51cd4664918454011094321e464"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages19d37cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "scapy" do
    url "https:files.pythonhosted.orgpackages67a12a60d5b6f0fed297dd0c0311c887d5e8a30ba1250506585b897e5a662f4cscapy-2.5.0.tar.gz"
    sha256 "5b260c2b754fd8d409ba83ee7aee294ecdbb2c235f9f78fe90bc11cb6e5debc2"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}pocsuite -k ecshop --options")
  end
end