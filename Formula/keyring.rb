class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/dd/f4/254b3a89f9cef31d75c98d14bd607b4603c77b8fb5fa72a63274fc365cd1/keyring-24.0.1.tar.gz"
  sha256 "f77da625a448baa77906b099be9feaa29aa90979547506ac1ec422926085cee0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e16e34ea88dbf061ef2f6e3a1e489b309b3e9f65ed3764c3e7bfb0cc35eb0af9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbbad487e061d30301ffae2b8a1489aaa56b44e816860f0b87a2f2a259ad4c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb4f07b78cc30e9d565a40afc4d207d7bc4281446a240eea496d07b0228bba92"
    sha256 cellar: :any_skip_relocation, ventura:        "e9eba9472322190b674b36d788ad1e17591c5df1ec04b362b797240350896d37"
    sha256 cellar: :any_skip_relocation, monterey:       "b1dd9d448644770a23b0c8c77bdf0d7869de1bd7d4e5ec0488bade864c51b8b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "81758b9ec92182ddd94f4b861f8a7bd89b774553caa3d3047849f292f0585de3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ab6a6b74472f0e6156597de1f3026f7b979375cf819562efff1c65c7e96d25"
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