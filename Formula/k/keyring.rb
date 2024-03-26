class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https:github.comjaracokeyring"
  url "https:files.pythonhosted.orgpackages93c36fafc393844ef43b36a5d908495ee49dd7e67f3568d4ae848a696daaf713keyring-25.0.0.tar.gz"
  sha256 "fc024ed53c7ea090e30723e6bd82f58a39dc25d9a6797d866203ecd0ee6306cb"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4745f51b6b7144a93a54955d2ee929907073aa8c93b92dab9fdc567089125122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4745f51b6b7144a93a54955d2ee929907073aa8c93b92dab9fdc567089125122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4745f51b6b7144a93a54955d2ee929907073aa8c93b92dab9fdc567089125122"
    sha256 cellar: :any_skip_relocation, sonoma:         "b067bb7570a68175ffefcef3c166869060290b42031246450e9747555499fbaf"
    sha256 cellar: :any_skip_relocation, ventura:        "b067bb7570a68175ffefcef3c166869060290b42031246450e9747555499fbaf"
    sha256 cellar: :any_skip_relocation, monterey:       "b067bb7570a68175ffefcef3c166869060290b42031246450e9747555499fbaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32757f9257ef2ed101ad09e156b407ddc913838811446c46740919cf8f75ce40"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "cryptography"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackagesa58aed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackages7cb4fa71f82b83ebeed95fe45ce587d6cba85b7c09ef3d9f61602f92f45e90dbjaraco.context-4.3.0.tar.gz"
    sha256 "4dad2404540b936a20acedec53355bdaea223acb88fd329fa6de9261c941566e"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackages577cfe770e264913f9a49ddb9387cca2757b8d7d26f06735c1bfbb018912afcejaraco.functools-4.0.0.tar.gz"
    sha256 "c279cb24c93d694ef7270f970d499cab4d3813f4e08273f95398651a634f0925"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "shtab" do
    url "https:files.pythonhosted.orgpackagesa9e413bf30c7c30ab86a7bc4104b1c943ff2f56c1a07c6d82a71ad034bcef1dcshtab-1.7.1.tar.gz"
    sha256 "4e4bcb02eeb82ec45920a5d0add92eac9c9b63b2804c9196c1f1fdc2d039243c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"keyring", "--print-completion", shells: [:bash, :zsh])
  end

  test do
    assert_empty shell_output("#{bin}keyring get https:example.com HomebrewTest2", 1)
    assert_match "-F _shtab_keyring",
      shell_output("bash -c 'source #{bash_completion}keyring && complete -p keyring'")
  end
end