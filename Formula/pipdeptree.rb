class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/89/86/cd4899dd11f30802f3ec5631ffc735ad120739c1e93ce51e4392ebc640b7/pipdeptree-2.9.5.tar.gz"
  sha256 "47bfc150560709420b647bcc6293868d6f0848fb33a7d9ccbfc0abe343999953"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5069c91f481928ae62b333403741da92aa7c6776d83f1a3657b646bf9bd45a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "472c01e1a8cdadb3e32ec3a1bd041bcdb2176bb592d2a5e6180202efea96d58d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "319e2b5ddec77247530d596d341eab63d1bc6231bb83b9f7ce376abd0b1b423b"
    sha256 cellar: :any_skip_relocation, ventura:        "cec989e8ec16e411408d99c7a93d85c0c2a901f053e68612bc221a34ddb84dc1"
    sha256 cellar: :any_skip_relocation, monterey:       "845407e31fd23b2c86cca5798b24215ced114850316c7fb51ad7587e22dcf105"
    sha256 cellar: :any_skip_relocation, big_sur:        "864910b740e12e3bac8200b3f7fa62f7058693971ee67b59552cc1c5e1f1abc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc8c75c531f6a4b9b2080572573eb3990e8d56d1fbd64510c173bb71de15fb71"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end