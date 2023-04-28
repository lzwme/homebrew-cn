class Censys < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for the Censys APIs (censys.io)"
  homepage "https://github.com/censys/censys-python"
  url "https://files.pythonhosted.org/packages/e1/6c/49b7f8a0e27412c3aabb5587417124a3e4c58a4371adba10f369362d0edb/censys-2.2.0.tar.gz"
  sha256 "ad0925d56b681bd9dd6f2a64fc33baf354adafa8bd307dc9a3320d2f9cfe22e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f96cf1ed469059d8ff65527fcb476a623fd1a4f290f4be98cf4eee36df91e1eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71e15a08f8e33d3029d2bdcf2cb31ae5c088da29af2c320017b32e8c68116b8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d525a10eb314b3bf44428fde4253e9b2fd5cec540df0d6f86a0d80a63657b6e"
    sha256 cellar: :any_skip_relocation, ventura:        "002fe7e0f24363d5840890a712d4e9a2b6ed1d81d448a9aa3c7c9404612dce0d"
    sha256 cellar: :any_skip_relocation, monterey:       "90d8cdafa09134cd8ae40877e58bd08d9b1ad718eb4a7a4f84644181f5a496f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f05ce607a6754d09950cf3aa58bdb75e09460447377890d5717cbc8d217fad73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fbe05049c571a38057897a0b99850fa5ab0dc8882388b73a88296e6c969e21"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/4c/d2/70fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdb/requests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/3d/0b/8dd34d20929c4b5e474db2e64426175469c2b7fea5ba71c6d4b3397a9729/rich-13.3.5.tar.gz"
    sha256 "2d11b9b8dd03868f09b4fffadc84a6a8cda574e40dc90821bd845720ebb8e89c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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