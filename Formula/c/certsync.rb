class Certsync < Formula
  include Language::Python::Virtualenv

  desc "Dump NTDS with golden certificates and UnPAC the hash"
  homepage "https:github.comzblurxcertsync"
  url "https:files.pythonhosted.orgpackagesdc0d34b200d297acf6f580daa64a611804ea2f139e38c7afcb17ceb5353b7ae8certsync-0.1.4.tar.gz"
  sha256 "ac97dd363b9f795ba34c79d7003ed213507a4b686f6021f47c62f707612cdba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8471628c6b02b96d656fffe5740d7b078c3660323105fbe4629f7c5954381258"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38e1077cc8ae26ad2e9db31bb2e62b83569cbe4f5d641fcc59e4608d5a2524b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04dce6540aebd41d985b3f620b2ddb4a3c2ddfa40550f88f7038485c67e3de81"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c8a00c5a7942677e532a880b84e264de24e04710f510fc467e68e6b3d31f004"
    sha256 cellar: :any_skip_relocation, ventura:        "ec4d5a0dd42855b5ca34d9cc70fe8e1f290e2a219f458815e4ff3e79f8d77ca2"
    sha256 cellar: :any_skip_relocation, monterey:       "68a25551461d8a78f62c09d9ce9c46d1c2a5027415e32e79ff301b6414d70f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1de24eba7da12dfb1d3828549b5373bfd00b8cc3a9beaa3caf67c9e6db7c2f"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python-markupsafe"
  depends_on "python@3.12"
  depends_on "six"

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

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "dsinternals" do
    url "https:files.pythonhosted.orgpackagesefe42ceffa1b0e1751e3470deaa4512f22d46b8e51ec2227c679b73dbe4165e5dsinternals-1.2.4.tar.gz"
    sha256 "030f935a70583845f68d6cfc5a22be6ce3300907788ba74faba50d6df859e91d"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackagesd809c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackages8f2ecf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ecfuture-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "ldap3" do
    url "https:files.pythonhosted.orgpackages43ac96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "ldapdomaindump" do
    url "https:files.pythonhosted.orgpackagesac7c16f9d8a257bd82de90bd5963556a9a17f8105596f181dee5777437ef8900ldapdomaindump-0.9.4.tar.gz"
    sha256 "99dcda17050a96549966e53bc89e71da670094d53d9542b3b0d0197d035e6f52"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesa4dbfffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages1a72acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025bpycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages14c909d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbfa0e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610epyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
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

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  # pypi artifact request, https:github.comskelsecunicryptoissues7
  resource "unicrypto" do
    url "https:github.comskelsecunicryptoarchiverefstags0.0.10.tar.gz"
    sha256 "3daefcdf8e71f9300032393ad85d7f22fc08d07dc05cf7776019b9480bd8506a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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