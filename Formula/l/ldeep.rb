class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https:github.comfranc-pentestldeep"
  url "https:files.pythonhosted.orgpackages3bd15767d53713542c68ce12f8104adef95fbbd5d612017c5b997142d125d6dbldeep-1.0.76.tar.gz"
  sha256 "4d254ea3a38ad0353530f69a483f69f0ba4abf64db595ddef9495cc0a532b1df"
  license "MIT"
  head "https:github.comfranc-pentestldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b0bdc5b8d61c16e37f441eb34559c16dfc04810f073bf7ef09c0066b9d5f8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3c9d3c6c7ef2f0c1022b538a5ad937bf92e1c1d00263cfffb827007c3762c74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "941233516e066b0e835fa352cdf886398101ddc900f9be969d2bef429b3b77ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c19bbb164b0faa2100430852e260319ab870f5c08a98c49349d311c02423ee9"
    sha256 cellar: :any_skip_relocation, ventura:       "7ff78120671dfad75d08c4325845f376722992e6ff2cd066de45710d4c7656cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6efb4b927aa9493bcc273362b21657aaa74c64b6e6f754cc235cfc9cbe6ea9e2"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "gssapi" do
    url "https:files.pythonhosted.orgpackages042ffcffb772a00e658f608e657791484e3111a19a722b464e893fef35f35097gssapi-1.9.0.tar.gz"
    sha256 "f468fac8f3f5fca8f4d1ca19e3cd4d2e10bd91074e7285464b22715d13548afe"
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
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages135213b9db4a913eee948152a079fe58d035bd3d1a519584155da8e786f767e6pycryptodome-3.21.0.tar.gz"
    sha256 "f7787e0d469bdae763b876174cf2e6c0f7be79808af26b1da96f1a64bcf47297"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages11dce66551683ade663b5f07d7b3bc46434bf703491dbd22ee12d1f979ca828fpycryptodomex-3.21.0.tar.gz"
    sha256 "222d0bd05381dd25c32dd6065c071ebf084212ab79bab4599ba9e6a3e0009e6c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages377288311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}ldeep ldap -d brew.ad -s ldap:127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap:127.0.0.1:389", output
  end
end