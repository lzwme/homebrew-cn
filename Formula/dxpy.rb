class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/56/b0/89185209a36f3c628910008edcd2446fcefca71b10abc35bd4c7f6b2714d/dxpy-0.348.0.tar.gz"
  sha256 "83b9e271121bdc581ffec433f00ac0794b43d154a8df1e7561d7f23cd9d88590"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e721f7e49719c3453580f98220ad3735c33ebb27c801c413d0ad5195030569d"
    sha256 cellar: :any,                 arm64_monterey: "5644ed94dcd2068b7856f19454318dbe13d1efb20f360b54ce78dfa96ef92674"
    sha256 cellar: :any,                 arm64_big_sur:  "a2d748fafe1f0d27ff0e2ed47e291fafa6a9eb4e5ab71d9debf4ab99a565bb97"
    sha256 cellar: :any,                 ventura:        "c2fa714102e74264a3a8cecd1cf9d27f060f73a534b5edb0495848fb22e7e144"
    sha256 cellar: :any,                 monterey:       "b2cd166673870491b7d31f152326a8def01d86ef86877f767914370f52b49df1"
    sha256 cellar: :any,                 big_sur:        "c675cb4568e1dc297f726278aa2a60d5a6091c75cda02d16705c2014338b0bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b604f9a5f477522cafa17ef38c2cc02122d995cd4a4376df17ad0cc1b1639b62"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/42/cd/fdb872d826b76b65b23147e83b1ca4c033445bbff59f8836a118657dd050/argcomplete-3.0.8.tar.gz"
    sha256 "b9ca96448e14fa459d7450a4ab5a22bbf9cee4ba7adddf03e65c398b5daeea28"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end