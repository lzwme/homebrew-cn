class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https://github.com/vzhd1701/evernote-backup"
  url "https://files.pythonhosted.org/packages/81/04/6da56e51723acf47fa7c9148b80caef1be590ce82e5c1394e3faaff9d345/evernote_backup-1.9.3.tar.gz"
  sha256 "5989ab363f8e225486cd7097545073260e52f1459a912ddd415779f0e0538c5f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "298b46c545c6b590023b38465bee503cb2c9a0476c45761990e38b4a200917d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afab45aa9da401ea982a9801afb3bf85afd0c34bb117ed70888240d91eef159e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4874a7d21e36d75b774f6b557f004170a881d6c25c4a4fde97e3454c6632482"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b1d60c818125c323281f5a40d4967ffedf7d7335be0bed1831216072448be9c"
    sha256 cellar: :any_skip_relocation, ventura:        "9ea7d30733aed3843a1f706e83f881fa61fbf6433a3bcbd3fdec7fb4f81d5540"
    sha256 cellar: :any_skip_relocation, monterey:       "2705cd481a89b88d9792b3829665944347474772222ff66862f84b4405278bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1cf3e219a529a044d04cab3028cee083aea9358082b9c7c6ae7bc7808358cad"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-pyparsing"
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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"evernote-backup", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/evernote-backup init-db -u test -p test 2>&1", 1)
    assert_match "Password login disabled", output

    assert_match version.to_s, shell_output("#{bin}/evernote-backup --version")
  end
end