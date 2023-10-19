class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/6c/a0/feb4dfa42e8cb1a0bd91667233254e49696cf6618f51ad5629f6efd89dae/git-remote-codecommit-1.17.tar.gz"
  sha256 "fd4a9ba3fbd88cd455a8e2087765e415da0beaae9932d4e84010069a536de24e"
  license "Apache-2.0"
  revision 2
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3084e88a86952977eda57eaec5c67cc922eae58d3f811f8f2b2a4c8921a4f42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d4632f0f3653dcbe896bfb3ccf72427bcfccb7ee0b165a766f55081920222ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e280cf2e2a9366a7dfe229a9523be9e0857cd71174d8aeb5d7a4a8b276ee05ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b86f8792be295dbd044110e31dc8762c476e47068e6f5943d1397c5caeb4c7d"
    sha256 cellar: :any_skip_relocation, ventura:        "9724ed02c830ea73ad8dbd6fd06796808d324a83bee2f10223b5b03fafe06337"
    sha256 cellar: :any_skip_relocation, monterey:       "d304f2d5bec2bde699e672a0afac100fb6835f1df5a86cf256d0be615e20e4ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a218dbf61c8daf3fa70cf75f75f64c2d275b7bbb7e2a35e3671ebb105f059c"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end