class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https:github.comjaracokeyring"
  url "https:files.pythonhosted.orgpackagesa51c2bdbcfd5d59dc6274ffb175bc29aa07ecbfab196830e0cfbde7bd861a2eakeyring-25.4.1.tar.gz"
  sha256 "b07ebc55f3e8ed86ac81dd31ef14e81ace9dd9c3d4b5d77a6e9a2016d0d71a1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6cccce628c975ed202c82d32483363a7e708cd829a7a1a23eafab9ba3fafd2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6cccce628c975ed202c82d32483363a7e708cd829a7a1a23eafab9ba3fafd2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6cccce628c975ed202c82d32483363a7e708cd829a7a1a23eafab9ba3fafd2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c162ac10b450bd6cf13e8c1716043db7542b131a5e8561235465dd6bc6567b3c"
    sha256 cellar: :any_skip_relocation, ventura:       "c162ac10b450bd6cf13e8c1716043db7542b131a5e8561235465dd6bc6567b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed9ef60eb416351eb9162ade5be974db8b9e7836e539e5dcb17a1f6da9fbab5"
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
    url "https:files.pythonhosted.orgpackagesdfadf3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackages03b16ca3c2052e584e9908a2c146f00378939b3c51b839304ab8ef4de067f042jaraco_functools-4.0.2.tar.gz"
    sha256 "3460c74cd0d32bf82b9576bbb3527c4364d5b27a21f5158a62aed6c4b42e23f5"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages517865922308c4248e0eb08ebcbe67c95d48615cc6f27854b6f2e57143e9178fmore-itertools-10.5.0.tar.gz"
    sha256 "5482bfef7849c25dc3c6dd53a6173ae4795da2a41a80faea6700d9f5846c5da6"
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