class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/6c/a0/feb4dfa42e8cb1a0bd91667233254e49696cf6618f51ad5629f6efd89dae/git-remote-codecommit-1.17.tar.gz"
  sha256 "fd4a9ba3fbd88cd455a8e2087765e415da0beaae9932d4e84010069a536de24e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfb0fbc091015095948385efcbbb0394d9c403c7d399a50d89082cb7b552cd2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c07270ba5b504729e9dfade32954b2f1918783e6f40507ed1d916943059ba6c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f89d42ef2c608cee219f062e8147993d5a797781ea44236f152e1bca1a1ab4b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8feb59d01c9c7c047915bf79bf7273ed20005ea79db3a856db9df6a256b1b92"
    sha256 cellar: :any_skip_relocation, ventura:        "e8bd1a9ae39fa3ec4e97ca6a0a598ed775f3e4f555bb13a8890cf8b788537382"
    sha256 cellar: :any_skip_relocation, monterey:       "3e814fe3f325495bd4c00243536e4fa7fa081156c384b9d8bcbd3015c3da461d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6553210dc4414e1e4aafef03bf836cba9f9459ec5bb2b4ecc3bd6c3b479863ef"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
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
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end