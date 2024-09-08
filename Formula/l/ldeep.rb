class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https:github.comfranc-pentestldeep"
  url "https:files.pythonhosted.orgpackages03f75301b9ff1ab0199c433acd7a4cee27682165dc95e615d27e160f80b9cc7aldeep-1.0.62.tar.gz"
  sha256 "1424d2c6f63d6e665e87c5d4a49d366b1cfced9d544c5f31b531520788954a3d"
  license "MIT"
  head "https:github.comfranc-pentestldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22746ed5fd94521d8c6728beadb801728959299cb1c59e6cf6ba3b44547ee1d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cab8935b0122b7a1eff3162027521fd03fc7ff090a2b31a8f59457aabf900b3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "873d1886067e1c7672467ac5d7530643707ca3ecd0a44dd65c425e274485912c"
    sha256 cellar: :any_skip_relocation, sonoma:         "53473f3a06c58bd2c1e23e281e8e3ae86fe6c7da43429ec39df9ae9502fc91e3"
    sha256 cellar: :any_skip_relocation, ventura:        "ac8caff601f3078d73a305b3ec64ed93be98e8c67c5085f8944ce8591a5c2371"
    sha256 cellar: :any_skip_relocation, monterey:       "7298a8eae56867a00263ccd57a3b3f9abb7103b35bc9feb9204e19dfa6a6bce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fcd7050ed9fe8590dd1f9e5bca1fb6368d40f8d77e71b0f7e11a02b238044bf"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "krb5"

  resource "asn1crypto" do
    url "https:files.pythonhosted.orgpackagesdecfd547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6eeasn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "commandparse" do
    url "https:files.pythonhosted.orgpackages796b6f1879101e405e2a5c7d352b340bc97d1936f8d54a8934ae32aac1828e50commandparse-1.1.2.tar.gz"
    sha256 "4bd7bdd01b52eaa32316d6149a00b4c3820a40ff2ad62476b46aaae65dbe9faa"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "gssapi" do
    url "https:files.pythonhosted.orgpackages13e7dd88180cfcf243be62308707cc2f5dae4c726c68f30b9367931c794fda16gssapi-1.8.3.tar.gz"
    sha256 "aa3c8d0b1526f52559552bb2c9d2d6be013d76a8e5db00b39a1db5727e93b0b0"
  end

  resource "ldap3-bleeding-edge" do
    url "https:files.pythonhosted.orgpackagesb6721f50f58d90ebc3900159db6b313f600b08460300543dab20f4087aa81eeeldap3_bleeding_edge-2.10.1.1337.tar.gz"
    sha256 "8f887372ac0e38da25e98a98f4b773f58a618cf99a705a15caa5273075b56999"
  end

  resource "oscrypto" do
    url "https:files.pythonhosted.orgpackages0681a7654e654a4b30eda06ef9ad8c1b45d1534bfd10b5c045d0c0f6b16fecd2oscrypto-1.3.0.tar.gz"
    sha256 "6f5fef59cb5b3708321db7cca56aed8ad7e662853351e7991fcf60ec606d47a4"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}ldeep ldap -d brew.ad -s ldap:127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap:127.0.0.1:389", output
  end
end