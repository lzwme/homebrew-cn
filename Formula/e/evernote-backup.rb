class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https:github.comvzhd1701evernote-backup"
  url "https:files.pythonhosted.orgpackages7709021f30d5e05df5587f0621b4144b687d94af331fefa54f5a14b7cd2d80d1evernote_backup-1.13.1.tar.gz"
  sha256 "564c39cd92633e9e9492346363bd3f85175c15a9f73d5c34d35835a2ef05e197"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c75cc66e5a495fe611aa9dbf89c88164fcdafb8f871a01c5b114447465f9b15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeddac93f09fe8b65c6f3b3623b137e587c432e82190d55281ab0c8eb4e4ec7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6a5ec3b0e34b9e4fb5ba960b4393e370ea75ef0489fa9ad9b2d6656acb122b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "75aa26f205a78318ef8caee2a92b9bbe3efa3ac1e1cae2aa0d99573ceaca4372"
    sha256 cellar: :any_skip_relocation, ventura:       "2089a26a8a7d9f47eb92c7ac2fa7a21c70bec848decbd1185dba2f7c97d5f446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b95f6cde456462a8331c8063ab13f30ba9b93da131f27d2b4cc89ac0612193c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab8ed22b2174b9435f3986a14cd6e78003d98077c81701105fb62d8bf699fd4"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagesb99f1f917934da4e07ae7715a982347e3c2179556d8a58d1108c5da3e8f09c76click_option_group-0.5.7.tar.gz"
    sha256 "8dc780be038712fc12c9fecb3db4fe49e0d0723f9c171d7cda85c20369be693c"
  end

  resource "evernote-plus" do
    url "https:files.pythonhosted.orgpackagesd8e8d43bebb6f532598c98a11d07d2c9a114bd11ba780dc40b1d74f7466926a9evernote_plus-1.28.1.dev2.tar.gz"
    sha256 "fb5e2e6785814205e623bc70c3a1b5abb47dc90a3a7ff28b3d3b0dbc5fb31881"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages9552531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49frequests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requests-sse" do
    url "https:files.pythonhosted.orgpackagesa15791c3be234a531164786622f74aed74610125cfa1a9e3b707df417479673erequests_sse-0.5.1.tar.gz"
    sha256 "42df8ad8b8428a44b3f27d2501b68d3f2dd6eaa8cf4cc82e9e53cc3d18eea9cd"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "thrift" do
    url "https:files.pythonhosted.orgpackages331c418058b4750176b638ab60b4d5a554a2969dcd2363ae458519d0f747adffthrift-0.21.0.tar.gz"
    sha256 "5e6f7c50f936ebfa23e924229afc95eb219f8c8e5a83202dd4a391244803e402"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"evernote-backup", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}evernote-backup init-db 2>&1", 1)
    assert_match "Logging in to Evernote...", output
    assert_match "OAuth requires user input!", output

    assert_match version.to_s, shell_output("#{bin}evernote-backup --version")
  end
end