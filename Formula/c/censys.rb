class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https:github.comcensyscensys-python"
  url "https:files.pythonhosted.orgpackagesd1219797900ebbed0fa2c961b2432a1c9cf9e41bbd6e8902debcf22ad9473d31censys-2.2.12.tar.gz"
  sha256 "da75c2e37f064b9ffd579650217cb8d3f129048949f997acee31a0cb34b6e0dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb1e857695d256001aac44fd5b1b1f0439d92550532c07d3c93f824611cc4dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb1e857695d256001aac44fd5b1b1f0439d92550532c07d3c93f824611cc4dfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb1e857695d256001aac44fd5b1b1f0439d92550532c07d3c93f824611cc4dfa"
    sha256 cellar: :any_skip_relocation, sonoma:         "74f7daa7a8c611143e3c0ea41ae2d9f5ff936ecd0f18568fe3935b5b660366f9"
    sha256 cellar: :any_skip_relocation, ventura:        "74f7daa7a8c611143e3c0ea41ae2d9f5ff936ecd0f18568fe3935b5b660366f9"
    sha256 cellar: :any_skip_relocation, monterey:       "74f7daa7a8c611143e3c0ea41ae2d9f5ff936ecd0f18568fe3935b5b660366f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c32dbbf0f926020bd7cd1b3fbdfd49fc44977bd1215d6817c26b1c1618f2c87"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages3cc0031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
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
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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