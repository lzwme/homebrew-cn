class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/2c/d2/bdf76a090f4b0afe254b03333bbe7df2a26818417cbb6f646dc1888104b7/git-remote-codecommit-1.16.tar.gz"
  sha256 "f8e10cc5c177486022e4e7c2c08e671ed35ad63f3a2da1309a1f8eae7b6e69da"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ef3adad3daaf8fd88f1a1fb349e2ae31bfe525201412c3291e775a19d84966"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9eb04b1e5bcb3bb3865616151c0f1623bff6a2290947505671ba5a302bf6927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "062a914e87f8ba41aa676d3a46b20823f03f6d5f350ddd0c72c128606051d7e4"
    sha256 cellar: :any_skip_relocation, ventura:        "5a990f540b94844cacfe46f88b39b3c80f99a378660560f6aab67e5e32f2072f"
    sha256 cellar: :any_skip_relocation, monterey:       "4e26950dfc93111777c733a7c8ffaf48240286b37dab08e97c8a91d1d9275607"
    sha256 cellar: :any_skip_relocation, big_sur:        "633630a3d3df1fb7d7f4e99e89b06cbbbb45413b314725f17156c6eb058f30dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b9786d4c53d05b8cf19dae7640325ff5117a4650d986736209e778527343f2"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1c/4f/c2755bd8a1636f17c470dc4c57ddd390b2c5f6505041c70133f7fa151815/botocore-1.29.36.tar.gz"
    sha256 "5cb1fb381c427fe12274eb866f2ff739169e0e1f33c2481a474ba2ff8ca43f75"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end