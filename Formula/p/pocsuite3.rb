class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https:pocsuite.org"
  url "https:files.pythonhosted.orgpackages0f05b17921332ab312c04ccc67b3d01a0d4318a4d45eb0315531f66d41a89639pocsuite3-2.0.8.tar.gz"
  sha256 "9508ffec49519e5421f19472a582d747b44bf3db289357ed39227e9addfceec3"
  license "GPL-2.0-only"
  head "https:github.comknownsecpocsuite3.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "c1b2768db9229bc541b148c61d9ef2c60e76f28ea1a4d6de9f13f98d78fdbde9"
    sha256 cellar: :any,                 arm64_ventura:  "b18dfc723b256ca4172c0af4754a11f2a333f21125723c4af263a88ab7d84e3c"
    sha256 cellar: :any,                 arm64_monterey: "70321dbdcae4d86eb856e3594c98c9c5ffd28b0d762cb606cc20610360dab510"
    sha256 cellar: :any,                 sonoma:         "1d286c8ec35bb7d68bee2eb859b603c019949b468ddb3cbbeb7c3cf3a52e96a9"
    sha256 cellar: :any,                 ventura:        "651aaded70b264481421e8c49ca87d2874e9e85be8dc6850ce5981d890a43111"
    sha256 cellar: :any,                 monterey:       "01e3c7d79a4bab49c95f01a4c0e798e5d356a2b1d94fd8b92fb9cf149247a367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc8ba846dd907250e6324bf0c59c8caea94e3ee9e9231a4691176d87ec7b45fe"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

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
    url "https:files.pythonhosted.orgpackages314b22a48749ffaf4d478192769d783233c37f00f0005d349dc6cf4da7003e3aFaker-24.1.0.tar.gz"
    sha256 "4fb0c16c71ad35d278a5fa7a4106a5c26c2b2b5c5efc47c1d67635db90b6071e"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jq" do
    url "https:files.pythonhosted.orgpackages2250ab53cc23eddad14a28920e95523b9f39849d9e3139836ec8fcbb7e8e3517jq-1.6.0.tar.gz"
    sha256 "c7711f0c913a826a00990736efa6ffc285f8ef433414516bb14b7df971d6c1ea"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "mmh3" do
    url "https:files.pythonhosted.orgpackages6396aa247e82878b123468f0079ce2ac77e948315bab91ce45d2934a62e0af95mmh3-4.1.0.tar.gz"
    sha256 "a1cf25348b9acd229dda464a094d6170f47d2850a1fcb762a3b6172d2ce6ca4a"
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

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackageseb81022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577dpyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
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

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
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
    # Multiple resources require `setuptools`, so it must be installed first
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}pocsuite -k ecshop --options")
  end
end