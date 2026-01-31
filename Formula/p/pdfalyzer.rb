class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/af/0e/b8135d1bc6d30a0baee6fd10df4c01d2590a1ff6f817009adf3085ced31d/pdfalyzer-1.19.4.tar.gz"
  sha256 "7bbb94f8342641de67cbeff2d186bb9b7a8c6ee4f31f3cc7db95dad3dc7996ef"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d294881fe7c662fad3b1de4f28ebfe6864798e2e14e82da1ceb49b6d57d6fdc"
    sha256 cellar: :any,                 arm64_sequoia: "a0209ef476e5930ef5413459762e54916c9ad2e1ed5316bf67209e9c56497694"
    sha256 cellar: :any,                 arm64_sonoma:  "5721d62edc7cd18144468c702c45070f563dd9ec28dfa1ab0ae66191e1b2bee6"
    sha256 cellar: :any,                 sonoma:        "eb3746507e86dbcf24803f18c9999bc50e118fee0c71661cecc044c3d8b274d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95428a22cfea80b64dcf7e97c081f96f28a4fdb55ade1de88acfe9b83bf36868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76677be8ed20e3c3f304b007e1d8a4ff54501fa389b7630be10e1c3ad354fcc2"
  end

  depends_on "openssl@3"
  depends_on "pillow"
  depends_on "python@3.14"

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
    url "https://files.pythonhosted.org/packages/d8/f4/801632a8b62a805378b6af2b5a3fcbfd8923abf647e0ed1af846a83433b2/pypdf-6.6.0.tar.gz"
    sha256 "4c887ef2ea38d86faded61141995a3c7d068c9d6ae8477be7ae5de8a8e16592f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
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
    url "https://files.pythonhosted.org/packages/50/70/c6fdd2f506adeafc1cfbe4d60ec213461b9848da2699773a1be226a44b14/yaralyzer-1.3.14.tar.gz"
    sha256 "125a03f7bc0ceb62fdaab2e18ef25f43542ae1b7baa6bc709ad93a92b3af824a"
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
    assert_match "Producer", output
    assert_match "OpenOffice.org 2.1", output
  end
end