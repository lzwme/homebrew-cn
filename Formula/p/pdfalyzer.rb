class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https:github.commichelcrypt4d4muspdfalyzer"
  url "https:files.pythonhosted.orgpackagese85ff899a7ada8e2f7a86434df93e76d2c683490af7ca021c1604b8bdace3835pdfalyzer-1.14.8.tar.gz"
  sha256 "7e1fc41d38e301ec4d86e4ad820ffaed32800bcb3bcac131329869e4084eb199"
  license "GPL-3.0-or-later"
  head "https:github.commichelcrypt4d4muspdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc802804ca9ecd1622d9bce046abf352bdb2dba2e38ea46f6b40f8bf694f3ca2"
    sha256 cellar: :any,                 arm64_ventura:  "1523cf9a931b6f317f10eef844458f6f51e4ab7d04fa15b7efe1f84c0e31a415"
    sha256 cellar: :any,                 arm64_monterey: "fa15ceb4d2856ccb2cebbb5965afddc56ee5710071365545e7a717291d8dedc4"
    sha256 cellar: :any,                 sonoma:         "00563988d97b95348570b8e3bbaa471bdf2a3396a5349aafbad3dc8092c1523c"
    sha256 cellar: :any,                 ventura:        "cab9cb4dc3fce05d03e16d147bffed12de204ffe2ba4042b85de96079477bfec"
    sha256 cellar: :any,                 monterey:       "47479969403d05e31fba170a27f0b3267334057c4577ddd3bd3e7661e3124821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9015dfc8cf91ec33766d28923a72a053145f7b1f3a4a1bf4cb0b36e873cda248"
  end

  depends_on "python@3.12"

  resource "anytree" do
    url "https:files.pythonhosted.orgpackagesf9442dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7deaanytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pypdf2" do
    url "https:files.pythonhosted.orgpackages77d6afcbdb452c335bccf22ec8ac5ac27b03222f9be8b96043bcce87ba1ce32aPyPDF2-2.12.1.tar.gz"
    sha256 "e03ef18abcc75da741a0acc1a7749253496887be38cd9887bcce1cee393da45e"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesf5d7d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages1123814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-argparse-plus" do
    url "https:files.pythonhosted.orgpackages9b3475eaf9752783aa93498d46ccbc7046e25cc1d44e5f6c43d829d90b9dcd02rich_argparse_plus-0.3.1.4.tar.gz"
    sha256 "aab9e49b4ba98ff501705678330eda8e9bc07d933edc5cac5f38671ee53f9998"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yara-python" do
    url "https:files.pythonhosted.orgpackages627b81789fafcc6167fe8cfd94b3813c0971a083cde142731213007e2456f35byara-python-4.5.0.tar.gz"
    sha256 "4feecc56d2fe1d23ecb17cb2d3bc2e3859ebf7a2201d0ca3ae0756a728122b27"
  end

  resource "yaralyzer" do
    url "https:files.pythonhosted.orgpackages23739adfae6d87a9faaaaaccf2766e75c364314c127c81366cfecc3cce1d735dyaralyzer-0.9.4.tar.gz"
    sha256 "a30f655e7e42221bdb069c2f4c6a8c67d10408f3d0f3e4be08dab7dbf0ffe6ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pdfalyze --version")

    resource "homebrew-test-pdf" do
      url "https:www.w3.orgWAIERtestsxhtmltestfilesresourcespdfdummy.pdf"
      sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
    end

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}pdfalyze dummy.pdf")
    assert_match "'Producer': 'OpenOffice.org 2.1'", output
  end
end