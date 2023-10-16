class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/6c/0b/3684b7e34c46045dda03b34be50392c689b23fa8788a0c0f7daf98db35d8/docker-squash-1.1.0.tar.gz"
  sha256 "819a87bf44c575c76d8d8f15544363a7a81ca2b176d424b67b39cd2cd9acc89e"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a9bdc6726210983b44d200b50907264325b3a8867b09bc7bc02117234c353ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d98d563af8fb296058921259b7ec6e11c5e84563296737a28c50db3ae30b7321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e35cc05f29fe47ac113d1c4007add77250d35af59e984c1d32dd2be50e3be2cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "844c6c9302b17e1dc97fa751e453926c0cd1d931e220b0ede1327c031192d2d3"
    sha256 cellar: :any_skip_relocation, ventura:        "2cbfe15f275ed1a8e862f77dae5c13e94d80a24d0d7b976a5aee08fcf06ab986"
    sha256 cellar: :any_skip_relocation, monterey:       "9b374bd78abd2c480216a60460fa3e621c5d318bd4a0083562f8d564689d4a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e05739d8863c0b21903a645e19509ebef4ef00c28d45c0d7764b3398a9d5fb2d"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
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

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "does-not-exist:1234"
    output = shell_output("#{bin}/docker-squash not_an_image 2>&1", 1)
    assert_match "Could not create Docker client", output
  end
end