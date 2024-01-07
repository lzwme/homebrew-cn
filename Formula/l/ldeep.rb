class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https:github.comfranc-pentestldeep"
  url "https:files.pythonhosted.orgpackages8f7cf62d3b31a9675e71712432a7423cd0d783689a50b830bd14f9265434b432ldeep-1.0.51.tar.gz"
  sha256 "ff372876aea6afbdb145218d6dabd600bb61bd5ae19b38b6dc40f8874bf72344"
  license "MIT"
  revision 1
  head "https:github.comfranc-pentestldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "081f6d3e2e85acf1e01c3daa6a32b1346170fd23564136f30ac53a1fcf8ac19b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4668a0372643a9cad3e9be4e51ba4c2613cf4efa97244ef2a1205251ddf1c7b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f2c63744e54356cf008be10d3b6e420820f161e635f5a829126d506d3569ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e658a522305f51ed800e851389323f0eac6e7f3a92e000aa43c6d01b1986828"
    sha256 cellar: :any_skip_relocation, ventura:        "63c22be8d7270284a4d4676475433dce439efd6b77b3de8138666370b43306b6"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c3064de0b0c0f43bf602b07685539b4e838e4c0b674a5f4c0cdb0cae8642ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d85c69b5735e1beb4f67ba90ab9eebea3b5e508b141f594f5e76583410fbf08"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "six"

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
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "gssapi" do
    url "https:files.pythonhosted.orgpackages13e7dd88180cfcf243be62308707cc2f5dae4c726c68f30b9367931c794fda16gssapi-1.8.3.tar.gz"
    sha256 "aa3c8d0b1526f52559552bb2c9d2d6be013d76a8e5db00b39a1db5727e93b0b0"
  end

  resource "ldap3" do
    url "https:files.pythonhosted.orgpackages43ac96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "oscrypto" do
    url "https:files.pythonhosted.orgpackages0681a7654e654a4b30eda06ef9ad8c1b45d1534bfd10b5c045d0c0f6b16fecd2oscrypto-1.3.0.tar.gz"
    sha256 "6f5fef59cb5b3708321db7cca56aed8ad7e662853351e7991fcf60ec606d47a4"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb13842a8855ff1bf568c61ca6557e2203f318fb7afeadaf2eb8ecfdbde107151pycryptodome-3.19.1.tar.gz"
    sha256 "8ae0dd1bcfada451c35f9e29a3e5db385caabc190f98e4a80ad02a61098fb776"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages3f1384f2aea851d75e12e7f32ccc11a00f1defc3d285b4ed710e5d049f31c5a6pycryptodomex-3.19.1.tar.gz"
    sha256 "0b7154aff2272962355f8941fd514104a88cb29db2d8f43a29af900d6398eb1c"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}ldeep ldap -d brew.ad -s ldap:127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap:127.0.0.1:389", output
  end
end