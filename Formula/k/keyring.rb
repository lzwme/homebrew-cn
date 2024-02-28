class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https:github.comjaracokeyring"
  url "https:files.pythonhosted.orgpackages69cd889c6569a7e5e9524bc1e423fd2badd967c4a5dcd670c04c2eff92a9d397keyring-24.3.0.tar.gz"
  sha256 "e730ecffd309658a08ee82535a3b5ec4b4c8669a9be11efb66249d8e0aeb9a25"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d08b487a5a1172b44b65495bf9a99e1e56d89f29755dfdb0a912ea38fefba5ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a47b6d3942a8df2bd420f63a2f6c9c3977ff8eb17a25082dc765dc698a8280f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a7321e4041d80a087470009c21b37e5a637ce0c899366de395f6d09328c451"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a9a23bbf942cd409f3b059820e20b205a9fe671f84fdb625414d28a5df69a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "9f389493905aef2527302f04b3ceb84204ba36856994d542c99e740288e1330d"
    sha256 cellar: :any_skip_relocation, monterey:       "aa654c84b3afb735b167b7e136c9280880edb73e0a89b8a93ed32ae143fccaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1810591f26ae54391a5f7d117b6764b6d2fc393f5f503280c07bcb7c6789551b"
  end

  depends_on "python@3.12"

  on_linux do
    depends_on "python-cryptography"

    resource "jeepney" do
      url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "secretstorage" do
      url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackagesa58aed955184b2ef9c1eef3aa800557051c7354e5f40a9efc9a46e38c3e6d237jaraco.classes-3.3.1.tar.gz"
    sha256 "cb28a5ebda8bc47d8c8015307d93163464f9f2b91ab4006e09ff0ce07e8bfb30"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "shtab" do
    url "https:files.pythonhosted.orgpackages18955691f59ef352d45017863bb6082d3c046a7cee2672458b4aa1850a12904ashtab-1.7.0.tar.gz"
    sha256 "6661c2835d0214e259ab74d09bdb9a863752e898bcf2e75ad8cf7ebd7c35bc7e"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"keyring", "--print-completion", shells: [:bash, :zsh])
  end

  test do
    assert_empty shell_output("#{bin}keyring get https:example.com HomebrewTest2", 1)
  end
end