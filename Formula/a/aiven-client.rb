class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https:docs.aiven.iodocstoolscli"
  url "https:files.pythonhosted.orgpackages21c23b05dce5bfce7fa1081ee460002ecf65e66349c49767c17cc423f0ab9e68aiven_client-4.1.1.tar.gz"
  sha256 "f2ccd6b140cfd86765e81cfcc2a949f030d9ec494b2c32802105d91b47e15ee5"
  license "Apache-2.0"
  revision 2
  head "https:github.comaivenaiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a547860dfe1bc09d099f4d400acf5107da0d6f3e52870bad6aebe418c4aa8f0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dad221d992e0b316a530d39031297ecd4ece414fde7edd86fe68d30077b4f35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfe683cd8f1c78e45886737427df191dd9ae800f7b0a90be1be207872168ecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5313fc680e3cba19dc08259a6856223d77103fc0abf4b330ae12d023c176f44"
    sha256 cellar: :any_skip_relocation, ventura:        "df001ae951eda8da77365d1113a8f378a5da7622b7b802965436016aefb7e516"
    sha256 cellar: :any_skip_relocation, monterey:       "2ca2e283da298f2e8710c35bcaa4a5553ac078e773b7379f340bf50ef2361fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87914a85699a0a87843c1e0fac621262d5eed47259be0b178346d9e3bd2db2a"
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
    url "https:files.pythonhosted.orgpackagesd8c1f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
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