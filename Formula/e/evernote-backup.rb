class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https:github.comvzhd1701evernote-backup"
  url "https:files.pythonhosted.orgpackages425041b3704d515025fbf6319e92a94db1c85cc9a6998a1a3ce67cee4bb46400evernote_backup-1.12.0.tar.gz"
  sha256 "74eb1d84882f7f2ca73878fa3e5fec9ec4e069861d68459f94e4d165e8ced36d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4b78dc2f60cdf4a9653fe20024fd4648ec538568347e83115fe315766dd1491"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29fb4a8c3ea8e1b331f0885900c5b4239d8d1c3c671bd1f031f652072086f091"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c56e30a9752117d987c05772e5bf87e945b925b67258bc30e0c7af2b5449a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb05319538bb8839473fc422d3e8556cbf57b4c9e296a2a66bbad7ca2e521738"
    sha256 cellar: :any_skip_relocation, ventura:       "72886b93c58b54be1fc3e441a06edbee5e22d0c564d60a8105f97dd51a0aef2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea7cbb990fe2bbfa846d2d25982eb9597114dc355c253c23db0c9184c4beb3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb8bbf340da8b020c2a9128c6d24fa1e019f75b57686a48a1a4217c29769ac9d"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
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
    url "https:files.pythonhosted.orgpackagesa05c01fdd4fdfccbe63949c93622b87dd68fd53e0e2203feed561e45c9750108evernote_plus-1.28.1.dev1.tar.gz"
    sha256 "40ae5b5c93745de65e90cb4d1bba1ff63946cbac4ae447b2641f1d1b0f82869e"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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