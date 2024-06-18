class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https:docs.aiven.iodocstoolscli"
  url "https:files.pythonhosted.orgpackagesbee234e73478db37847c94c51fd5b6b4f7e6618f5070a4f2f1fd24f17ab05466aiven_client-4.2.0.tar.gz"
  sha256 "8383b984324e3e126e12fba1e75963b29458ff4098969020ac4532c31da32b40"
  license "Apache-2.0"
  revision 1
  head "https:github.comaivenaiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce05734981008a11ad2ea8c4d79ae48e50d09ea7a35670a92028e5b630bda597"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce05734981008a11ad2ea8c4d79ae48e50d09ea7a35670a92028e5b630bda597"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce05734981008a11ad2ea8c4d79ae48e50d09ea7a35670a92028e5b630bda597"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce05734981008a11ad2ea8c4d79ae48e50d09ea7a35670a92028e5b630bda597"
    sha256 cellar: :any_skip_relocation, ventura:        "ce05734981008a11ad2ea8c4d79ae48e50d09ea7a35670a92028e5b630bda597"
    sha256 cellar: :any_skip_relocation, monterey:       "ce05734981008a11ad2ea8c4d79ae48e50d09ea7a35670a92028e5b630bda597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8e3d6e402bc0c8b926a8c47b41deefc7a702c6dc24336fb1bb7d4cea684624"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=tmp #{bin}avn user info 2>&1")
  end
end