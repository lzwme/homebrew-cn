class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/36/00/f4f829a20f3de7c95e77cf6de743559315c3fc28342175ea574331acc742/aiven_client-3.1.0.tar.gz"
  sha256 "a5cc6d80942321fc718776013c9ef2eb5fae48525a1757ca387abeb5e77e3da6"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55ce30b42d71d7f9925dd09ef453efec6d007d96e5a6aa76138758f917994507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c7889ca065d676d016801f2a120019b5ecb06a56107853fa91301dc6a8ec3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3d10ddb8d0d107f72782a6fb5e1fbc318c2de1d7f2338fe57e3cd77a5260442"
    sha256 cellar: :any_skip_relocation, ventura:        "cd92aef12792312e2be24ba0ae2a203a83fd9b92b0945d33bd1468f7c4c85d85"
    sha256 cellar: :any_skip_relocation, monterey:       "b28997fca577c4ad1ae9d23c44e16c6d122b4ddc3f830712890694c86237df76"
    sha256 cellar: :any_skip_relocation, big_sur:        "f692a814c64cfdb5f4bfcb30f5d6d98557a85b4f2fd45ef29e5ecfe8696893a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd79eff056419f7ae6f70e5b147f4e3115bbb8655cd43e5ae0661fb34c09c6b1"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end