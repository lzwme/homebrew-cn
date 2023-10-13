class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/09/5b/98f022bc96ceb68b12fb4cfe6fdf52cc3051fa0b7bf51dc805521afe72bd/awscurl-0.31.tar.gz"
  sha256 "6ce032543c0ec00857ce9c08cafe8041270b5508b08ec73e264e63f1e1255601"
  license "MIT"
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf46a701e81a0fc2b4235ba9e29e7cbdc84b51a63de46cf0098e2fd75be37fa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9044374037b12a3efa1484cbdd7211048e85f81fdbc04e3e28c984e5fae97a56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5020ff1cdd50cee0bfc0f6bd139f087cc30eb0933ac9c5c0fab21705f99215bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "c73a83396b87d96d1a0db07b8a716048969d3bdcfea4f5d2a418a5a6f0c1f325"
    sha256 cellar: :any_skip_relocation, ventura:        "bcdd3d41aae6b1af19190e0c9f13e1e211f79e05165230551e670a69ced25187"
    sha256 cellar: :any_skip_relocation, monterey:       "9f6515773f5201cdfdd3f744d4265de497fe351bdd732d817a389f46ec99e83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f70f0d8c10124e80b736c7cd18dc000d8c78dcb11326eddc424e155cd26d6eb"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-non-existent-bucket.s3.amazonaws.com 2>&1", 1)
  end
end