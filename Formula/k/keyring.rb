class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/14/c5/7a2a66489c66ee29562300ddc5be63636f70b4025a74df71466e62d929b1/keyring-24.2.0.tar.gz"
  sha256 "ca0746a19ec421219f4d713f848fa297a661a8a8c1504867e55bfb5e09091509"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb207b6f641c2ff7961319af501360fd9ee77247ca443bc29e31f896f6e4cfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b527b69ed89f91958d64a6dd2b2b04eb520a89941b43f6d420d7e740fb89bc9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4513434e3f247a7106767ff10e5682495ee45af8644e5c0c644dad52f8a9c39"
    sha256 cellar: :any_skip_relocation, sonoma:         "dded1608eb74f126ec6b78a26ab6b01818af3fc2842721efe34c15442a78a1d2"
    sha256 cellar: :any_skip_relocation, ventura:        "051d8b236aeefb5a2e0be6a2184b2937a30353b673e57ad0905a60b43e99ec2e"
    sha256 cellar: :any_skip_relocation, monterey:       "f15be5fcfb67ae863aa19f7adc2548e0b186cd7df4a44ad502ea7719db91b6e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861e579bbfb8fc83eb38ee6c1685abd366e67ae65e5ceed7fe6f4b8226a82a00"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.12"

  on_linux do
    depends_on "python-cryptography"

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

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/72/5c/6614a030e5308c244f3fb7ada978d3860720d8dc69522c651d3052c50e8c/shtab-1.6.4.tar.gz"
    sha256 "aba9e049bed54ffdb650cb2e02657282d8c0148024b0f500277052df124d47de"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"keyring", "--print-completion", shells: [:bash, :zsh])
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
  end
end