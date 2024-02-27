class Certsync < Formula
  include Language::Python::Virtualenv

  desc "Dump NTDS with golden certificates and UnPAC the hash"
  homepage "https:github.comzblurxcertsync"
  url "https:files.pythonhosted.orgpackagesdc0d34b200d297acf6f580daa64a611804ea2f139e38c7afcb17ceb5353b7ae8certsync-0.1.4.tar.gz"
  sha256 "ac97dd363b9f795ba34c79d7003ed213507a4b686f6021f47c62f707612cdba8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b5762ebf1ef4958a2715a09edc7e3ca3f0e0b9bdb75549cdf53bf1d1a51a706"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57d00b93be370af96b669dee47d90107ac97f5d9a2fcad52a61360047fd22126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29949d4c7b3a28276800c0d7a9cad13fdf9ba069f374ce09855f6747bb6dbbeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2011db6a82c9616e3b30dc0d8393589f920a74debc537240727ca41db3569e16"
    sha256 cellar: :any_skip_relocation, ventura:        "80e1443ec78b2e4ccef181bdf12de21d9555c71b8069e6000372f15b851a5b00"
    sha256 cellar: :any_skip_relocation, monterey:       "11f28ea7d5253cdd34a76d43fab50c0b3ce737e1dea571ad0ac4f6ecdbcfd5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49de264b89d0fc16a6644f5f40502f5b49beb0002c1a1b97cc0842a798c20345"
  end

  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "asn1crypto" do
    url "https:files.pythonhosted.orgpackagesdecfd547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6eeasn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackagesa1136df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9eblinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "certipy-ad" do
    url "https:files.pythonhosted.orgpackagesfffd349505ced12b137fc05c174fde5b798fcefa032dfbd8bf70549a65598e42certipy-ad-4.8.2.tar.gz"
    sha256 "03aa7e898eff2946c32494f82c2f156afbbc966fd157e599780ab19d638eaf50"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "dsinternals" do
    url "https:files.pythonhosted.orgpackagesefe42ceffa1b0e1751e3470deaa4512f22d46b8e51ec2227c679b73dbe4165e5dsinternals-1.2.4.tar.gz"
    sha256 "030f935a70583845f68d6cfc5a22be6ce3300907788ba74faba50d6df859e91d"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackages3fe0a89e8120faea1edbfca1a9b171cff7f2bf62ec860bbafcb2c2387c0317beflask-3.0.2.tar.gz"
    sha256 "822c03f4b799204250a7ee84b1eddc40665395333973dfb9deebfe425fefcb7d"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "impacket" do
    url "https:files.pythonhosted.orgpackages37e91b6f8ec2137b41f141ffc61dca5a9eacd597d4e523c40781eaa005e39b59impacket-0.11.0.tar.gz"
    sha256 "ee4039b4d2aede8f5f64478bc59faac86036796be24dea8dc18f009fb0905e4a"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages7fa1d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "ldap3" do
    url "https:files.pythonhosted.orgpackages43ac96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "ldapdomaindump" do
    url "https:files.pythonhosted.orgpackagesac7c16f9d8a257bd82de90bd5963556a9a17f8105596f181dee5777437ef8900ldapdomaindump-0.9.4.tar.gz"
    sha256 "99dcda17050a96549966e53bc89e71da670094d53d9542b3b0d0197d035e6f52"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesa4dbfffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb9ed19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages31a4b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackageseb81022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577dpyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "pyspnego" do
    url "https:files.pythonhosted.orgpackages3ac3401a5ae889b51f80e91474b6acda7dae8d704c6fe8424fd40e0ff0702812pyspnego-0.10.2.tar.gz"
    sha256 "9a22c23aeae7b4424fdb2482450d3f8302ac012e2644e1cfe735cf468fcd12ed"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-ntlm" do
    url "https:files.pythonhosted.orgpackages7aad486a6ca1879cf1bb181e3e4af4d816d23ec538a220ef75ca925ccb7dd31drequests_ntlm-1.2.0.tar.gz"
    sha256 "33c285f5074e317cbdd338d199afa46a7c01132e5c111d36bd415534e9b916a8"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  # pypi artifact request, https:github.comskelsecunicryptoissues7
  resource "unicrypto" do
    url "https:github.comskelsecunicryptoarchiverefstags0.0.10.tar.gz"
    sha256 "3daefcdf8e71f9300032393ad85d7f22fc08d07dc05cf7776019b9480bd8506a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages0dccff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53dwerkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}certsync -randomize -dc-ip localhost 2>&1")
    assert_match "Got error: nameserver localhost is not a dns.nameserver.Nameserver", output

    assert_match "Dump NTDS with golden certificates", shell_output("#{bin}certsync -h")
  end
end