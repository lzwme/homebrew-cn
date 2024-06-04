class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https:docs.aiven.iodocstoolscli"
  url "https:files.pythonhosted.orgpackagesbee234e73478db37847c94c51fd5b6b4f7e6618f5070a4f2f1fd24f17ab05466aiven_client-4.2.0.tar.gz"
  sha256 "8383b984324e3e126e12fba1e75963b29458ff4098969020ac4532c31da32b40"
  license "Apache-2.0"
  head "https:github.comaivenaiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caddec0a16ea83ceece06b73df589cadbdc797473bc8078cd048ac2fa26a3331"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caddec0a16ea83ceece06b73df589cadbdc797473bc8078cd048ac2fa26a3331"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caddec0a16ea83ceece06b73df589cadbdc797473bc8078cd048ac2fa26a3331"
    sha256 cellar: :any_skip_relocation, sonoma:         "caddec0a16ea83ceece06b73df589cadbdc797473bc8078cd048ac2fa26a3331"
    sha256 cellar: :any_skip_relocation, ventura:        "caddec0a16ea83ceece06b73df589cadbdc797473bc8078cd048ac2fa26a3331"
    sha256 cellar: :any_skip_relocation, monterey:       "caddec0a16ea83ceece06b73df589cadbdc797473bc8078cd048ac2fa26a3331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6b8c799cd06ff8527b088594a4464365c82478f760f948445d44f42a9ae30d"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=tmp #{bin}avn user info 2>&1")
  end
end