class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/27/05/bdde8a0a85a59e06cc243e07145884ab58fe50540f957ce5ee3d9dedce52/aiven_client-3.1.1.tar.gz"
  sha256 "421a00c9955b8704812395cc7add3bacb03977657cd87391028fdb9894252509"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77f750bd7e72caf4138cc7bd945df66d4f1d7e3f86910d7317cb1d7b4e506104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7afd66f8ef686dbe93417dd72359c3dde864d09cf61a5b413927cefb041687c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c68a2ef02f1eac8658832d2898401387d7936fb6ef9c80fcf219aa330b9226"
    sha256 cellar: :any_skip_relocation, sonoma:         "83516b3b950de2cf1a0afe5ae6faa8fb10b113d6ba052d9519ffb57a99c30c6e"
    sha256 cellar: :any_skip_relocation, ventura:        "1426b787042658007b3bdda306b017f07c4831ce81fd1bfddb4a746503f76618"
    sha256 cellar: :any_skip_relocation, monterey:       "76a6bdc25c72fe4bb2a34fa7606ad1055a85c1b2a9094454d80316a1571f2c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d8f8ef5a5c46c72ac5aa78b72667c4734db0d5f425b6d26f4e67e7c28a4a07"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end