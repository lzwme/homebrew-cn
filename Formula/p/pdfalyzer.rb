class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/69/e4/39183a9674a5eb292143d9a3dd1c4fa9541fffcf567f5295efefd5be86db/pdfalyzer-1.19.6.tar.gz"
  sha256 "888df3252f73fe28132a017824bc60f7a686c6a05800f3b026f76f48ee655dd3"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "1eab5bf3e528016a8466b886eac1f14aae9f6fa7d9232d8ce6724e6305780f4e"
    sha256 cellar: :any, arm64_tahoe:       "c669fef059da5e192a88d9306423424c9d6803257be5929e26efe7fb2efebe8c"
    sha256 cellar: :any, arm64_sequoia:     "24c97c9c468d228b47468c6746703e05707d939b24c8aeb0292ff283f2eaf43b"
    sha256 cellar: :any, arm64_linux:       "2b7240d07aa58ceb139e7e2179600c3ba08f4792f4bb02f8754292b09c131f57"
    sha256 cellar: :any, x86_64_linux:      "5fcf1323b4439cce5af256fc9840bf5a076e7e941bc06ed1527b44ecacb22226"
  end

  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "yara"

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
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/d8/f4/801632a8b62a805378b6af2b5a3fcbfd8923abf647e0ed1af846a83433b2/pypdf-6.6.0.tar.gz"
    sha256 "4c887ef2ea38d86faded61141995a3c7d068c9d6ae8477be7ae5de8a8e16592f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
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
    url "https://files.pythonhosted.org/packages/be/9a/2751156fa98de5ea0aeff92006273d384110e5696030e04080862412f3b8/yaralyzer-1.3.17.tar.gz"
    sha256 "d33fc7a6361ca780bd019602bfee5f0834dd3b1a65f169981e4ffbbaf4664442"
  end

  resource "homebrew-test-pdf", :test do
    url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
  end

  def install
    venv = virtualenv_install_with_resources without: "yara-python"

    resource("yara-python").stage do
      inreplace "setup.py", "self.dynamic_linking = None", "self.dynamic_linking = True"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfalyze --version")

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}/pdfalyze dummy.pdf")
    assert_match "Producer", output
    assert_match "OpenOffice.org 2.1", output
  end
end