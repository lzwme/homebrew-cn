class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/0f/f0/00f7863b9b836ab5cec317defdaeed6ea232f14456c2e15933662b9bfdf7/pdfalyzer-1.16.13.tar.gz"
  sha256 "1ac1bb2b6ba17960eacdbc6a2b5e08be9e30c03d7b84639f67d9542b4057a333"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b2392e5ffea8d4c7c636b81dbafc1bed22e06bb543dda5821af1906c5a7ccf8"
    sha256 cellar: :any,                 arm64_sonoma:  "530bb28ecec232fb638823c430ff7cccd7a37e56e6b0d00c149dd941c1f13553"
    sha256 cellar: :any,                 arm64_ventura: "a38bfbd300b347ce669255301710891b565548ba2eff66f436b4e22520c203e5"
    sha256 cellar: :any,                 sonoma:        "bcafd6bfd96e47b0ec1486e506bf5cb6f2080f90fc7185badcf95488d3be8f17"
    sha256 cellar: :any,                 ventura:       "0cd63e4806de2968d529b59083f832ceebfd319695154a60c03b92d8902f157c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dcc5cae43bfdb28701317f0a2418d2ea02093b19d79317a47b9b8ec92fb3b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2477e619c7d65139a6bd2f99a9caad5f75ad7eccf524c7209df2b1dffdc5a06a"
  end

  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/20/ac/a300a03c3b34967c050677ccb16e7a4b65607ee5df9d51e8b6d713de4098/pypdf-6.0.0.tar.gz"
    sha256 "282a99d2cc94a84a3a3159f0d9358c0af53f85b4d28d76ea38b96e9e5ac2a08d"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f5/d7/d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1/python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-argparse-plus" do
    url "https://files.pythonhosted.org/packages/9b/34/75eaf9752783aa93498d46ccbc7046e25cc1d44e5f6c43d829d90b9dcd02/rich_argparse_plus-0.3.1.4.tar.gz"
    sha256 "aab9e49b4ba98ff501705678330eda8e9bc07d933edc5cac5f38671ee53f9998"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  resource "yaralyzer" do
    url "https://files.pythonhosted.org/packages/48/7b/d50dab2395c1fd750da6395eca139021c779f7ca8eb6e0e9b3a287cbb5ca/yaralyzer-1.0.7.tar.gz"
    sha256 "925e23ad0466fbfc25be70d6053c553888b06723fc03fa607e7cf526932cf92b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfalyze --version")

    resource "homebrew-test-pdf" do
      url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
    end

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}/pdfalyze dummy.pdf")
    assert_match "'/Producer': 'OpenOffice.org 2.1'", output
  end
end