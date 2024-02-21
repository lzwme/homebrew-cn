class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https:github.commichelcrypt4d4muspdfalyzer"
  url "https:files.pythonhosted.orgpackagesfd86d235c3936af7638eed693648d9bf651930dd384aa50d11250e5db9d6b4abpdfalyzer-1.14.6.tar.gz"
  sha256 "d992de52f060559d0ff0086c0fff05fd86219fb8ffe3a48f8c03a7debee98809"
  license "GPL-3.0-or-later"
  head "https:github.commichelcrypt4d4muspdfalyzer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "2c0f0b1d48ca01c79926189a57b7114b6fc288fedf2db401c5ec95160fdca9db"
    sha256 cellar: :any,                 arm64_ventura:  "36cfbd9bd62465957031378a339a88db016dac1fff9b0975537ff8c737501477"
    sha256 cellar: :any,                 arm64_monterey: "b4fcd09b183e6d61e8a3761f46013dd52f34094231a3858b159876a579041bcd"
    sha256 cellar: :any,                 sonoma:         "4f17e5f4dda715238dc59cef1cc31c031dbac222091c73e1e09aaf98dc23a8c8"
    sha256 cellar: :any,                 ventura:        "72ef133b021ef8db56ff91f39f893bb4d0ae4a6095f95c8cdf48f31641b33215"
    sha256 cellar: :any,                 monterey:       "235d466a63e4ca8b98ec3b6f6afa132be7dc9ace155e36a01453752f6280a803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6ec12f4c845654ead9fba8340a5ef0a0e7443623fd921e3d94766b812db0904"
  end

  depends_on "python@3.12"

  resource "anytree" do
    url "https:files.pythonhosted.orgpackages7e8451e270f1f117da92025427e5cddd71ee62fc65de8b0391568055eb872d3danytree-2.12.0.tar.gz"
    sha256 "0dde0365cc8b1f3531e927694f39b903c360eadab2be09c50f3426ecca967949"
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
    url "https:files.pythonhosted.orgpackagesa42bd36b6399027bb888faed23e3393f4efc3568996a5c386233b364d9e701d5yara-python-4.2.3.tar.gz"
    sha256 "31f6f6f2fdca4c5ddfeed7cc6d29afad6af7dc259dde284df2d7ea5ae15ee69a"
  end

  resource "yaralyzer" do
    url "https:files.pythonhosted.orgpackages27ab53c0702f351334c1014eff376d67b31e2628197e3ad75a4824c3858512cayaralyzer-0.9.3.tar.gz"
    sha256 "d8d2fbb8b12733b3d0623c6de3a7c3ec29dcb040cfdb647bdad811fdf94981a6"
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