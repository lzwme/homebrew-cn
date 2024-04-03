class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https:github.comjaracokeyring"
  url "https:files.pythonhosted.orgpackages18eccc0afdcd7538d4942a6b78f858139120a8c7999e554004080ed312e43886keyring-25.1.0.tar.gz"
  sha256 "7230ea690525133f6ad536a9b5def74a4bd52642abe594761028fc044d7c7893"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ec0d9eaffdfd02b4e64328f69c8b5190b947553235710a32b588d4b33a8ddc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ec0d9eaffdfd02b4e64328f69c8b5190b947553235710a32b588d4b33a8ddc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ec0d9eaffdfd02b4e64328f69c8b5190b947553235710a32b588d4b33a8ddc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "072bdceb4120fccf262fe56f59471ca338c2606294346acbe91a3d70ee3acef0"
    sha256 cellar: :any_skip_relocation, ventura:        "072bdceb4120fccf262fe56f59471ca338c2606294346acbe91a3d70ee3acef0"
    sha256 cellar: :any_skip_relocation, monterey:       "072bdceb4120fccf262fe56f59471ca338c2606294346acbe91a3d70ee3acef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a7c2ec54ca898789110aae8561ac6a30fe2283f9cdb43de35c71cf2e77c8921"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "cryptography"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
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