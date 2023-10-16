class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https://github.com/vzhd1701/evernote-backup"
  url "https://files.pythonhosted.org/packages/c6/2e/28f97f59b92edde07895d6c95596b99313bb1a2cd0296ac2fd36f8954cb4/evernote-backup-1.9.2.tar.gz"
  sha256 "ec21025d614ec68ed5dc8d2028f2f856630a36b3b84f135952660bec7bdf70ad"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d846ddc6b769df8345ffc29445585f70af516ae0e1d7f6c93b3375854cdde7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b845e0ebd2dc049cfe96a33daf7eaac0b7c85b59c29a5a1773dd8724c6bda70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5d51d7c9a08f5bef718b153733c2f5886d78713ef1879a9a5857e47e4417374"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5798ab0b6cda43f5fdd53a35919883d24c74f9712d8c975d3f6b12151e82fef"
    sha256 cellar: :any_skip_relocation, ventura:        "74e4f7b08539f1ddeed073edb3a1d10ec3256025164e6c064846122af79ef7fa"
    sha256 cellar: :any_skip_relocation, monterey:       "634935a2d42f0fe5fce269b630bde483a7dbc14d56a902992e241e8d735c93c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0903f53fdcedbaef5a69ca1e360970ca3fcfc2c0688216239c14c41749e2d30e"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/e7/b8/91054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7/click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "evernote3" do
    url "https://files.pythonhosted.org/packages/7c/7e/2da47f29c4b1a14945ef143a3b784d50dd9d73595a4c397f34fa481a4e5c/evernote3-1.25.14.tar.gz"
    sha256 "e7914bb7cefb30e0ea509e82e1f176670359a154e30006f5160a0bcfd936cfd0"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "oauth2" do
    url "https://files.pythonhosted.org/packages/64/19/8b9066e94088e8d06d649e10319349bfca961e87768a525aba4a2627c986/oauth2-1.9.0.post1.tar.gz"
    sha256 "c006a85e7c60107c7cc6da1b184b5c719f6dd7202098196dfa6e55df669b59bf"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/evernote-backup init-db -u test -p test 2>&1", 1)
    assert_match "Password login disabled", output

    assert_match version.to_s, shell_output("#{bin}/evernote-backup --version")
  end
end