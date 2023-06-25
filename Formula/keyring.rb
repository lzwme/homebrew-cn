class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
  sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7f3e472c7a483e81bdddeae0baa54fe586181dd413060b916457225afc258cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed32337a22d299de8266b59aa2dca4461f462efbb30ed66e418a74b1b65db135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fe56c2c40173066b259583197f1388316ac9d040b69eee0028678e87a2444ea"
    sha256 cellar: :any_skip_relocation, ventura:        "1afbd3121037873450cf015cb7ddbfdc34e64dfedace1df1088fe49bb15ebf34"
    sha256 cellar: :any_skip_relocation, monterey:       "cb657a348a40a4aa4f854ef53de0fe2a040c306995ea9ac206ab9384f4f691d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd80b16c38ff3cd7f949ea1f0da9dfa6cb7d69aadd886edc4cf8c9a6b218171a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb846f300f84346de29a207313c433a7974727015157d35d0eef360a5a59077d"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build # for cryptography
    depends_on "rust" => :build # for cryptography
    depends_on "openssl@1.1"

    resource "cryptography" do
      url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
      sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
  end
end