class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https:github.comcensyscensys-python"
  url "https:files.pythonhosted.orgpackagesd1219797900ebbed0fa2c961b2432a1c9cf9e41bbd6e8902debcf22ad9473d31censys-2.2.12.tar.gz"
  sha256 "da75c2e37f064b9ffd579650217cb8d3f129048949f997acee31a0cb34b6e0dd"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14f606d6f10b2b8a5257177768c1ac9599366c3f45771b15b21d6ce50f488f7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14f606d6f10b2b8a5257177768c1ac9599366c3f45771b15b21d6ce50f488f7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14f606d6f10b2b8a5257177768c1ac9599366c3f45771b15b21d6ce50f488f7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b08270aa227459cdc5357406b74014e3f4b552da4fffe5e6fdd4fc9a14bf95f4"
    sha256 cellar: :any_skip_relocation, ventura:        "b08270aa227459cdc5357406b74014e3f4b552da4fffe5e6fdd4fc9a14bf95f4"
    sha256 cellar: :any_skip_relocation, monterey:       "b08270aa227459cdc5357406b74014e3f4b552da4fffe5e6fdd4fc9a14bf95f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f9b20ffaa7a6d3e621c2b75eda7cfd94986513e3031ae28cf20294982c65cbf"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesdbca45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91fargcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}censys asm config", "test\nn\n", 0)
  end
end