class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/d2/2f/1b7c7cb70c5e49d89a8d4545c1c5f3b42f68e470331512356d8a27f23041/censys-2.2.4.tar.gz"
  sha256 "2bcace81886b490b8e9b89e9269ee78ec7442631f5ac6e3fae8c94421a2b9d09"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8b7850b79b4da9f8af67c5d6b756cd348eafc3c81fea748d0351e8e1bf3b461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e824e2ebfb8fd9efdce7bf2161df5075eafeb4e865c09dc873b50fc97b768b44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "214883893b5f6c5c386f0c6d9c0843f4bb38e64f324a83ed8c912ccbad2a8a03"
    sha256 cellar: :any_skip_relocation, ventura:        "04b0906afa31e3c1677ffe55ab53da680c3f6d80b2861462600a2e9809d57b7e"
    sha256 cellar: :any_skip_relocation, monterey:       "03c2544a15a4d4d144599e2ffafe9afb8a32e43ab34adf166a95a0fd3eacaa70"
    sha256 cellar: :any_skip_relocation, big_sur:        "5906850a3efb6591ee96a94530fc189a21158e5b53efdffd7f443218417e6960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf5a40c2299965d3e7f2552dfac7a83fb56b59eabf574a91cb8db4d048d680ed"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: censys", shell_output("#{bin}/censys --help")
    assert_equal "Censys Python Version: #{version}", shell_output("#{bin}/censys --version").strip
    assert_match "Successfully configured credentials", pipe_output("#{bin}/censys asm config", "test\nn\n", 0)
  end
end