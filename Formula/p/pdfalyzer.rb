class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/fd/86/d235c3936af7638eed693648d9bf651930dd384aa50d11250e5db9d6b4ab/pdfalyzer-1.14.6.tar.gz"
  sha256 "d992de52f060559d0ff0086c0fff05fd86219fb8ffe3a48f8c03a7debee98809"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "449ac9a9574f98ee7fa11cc855f2a11393608c0589ee643b63faedf02813787c"
    sha256 cellar: :any,                 arm64_ventura:  "6efac9b3a0d2b61c017178ea724b2f31d74e546ed488128f78f296dd6f415284"
    sha256 cellar: :any,                 arm64_monterey: "eadd3d5b8045c4e72f18c42eb87636215a8c763f70f4417077760dd4d1450660"
    sha256 cellar: :any,                 sonoma:         "752098bf250bde7120c5b0ac0f59f1ff9119f78569a1dd409d0edba29ed7509c"
    sha256 cellar: :any,                 ventura:        "be9aac13759a1ab24b986ef3f05d864a418a35103a40e7416c911f5697be64cb"
    sha256 cellar: :any,                 monterey:       "3579bfebfd5c973889a36841ba0213a8d792cd10b766b6ba6c5e004a394a68ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31413d287afe27ff90172964e64d83348b5f9b0d848cb3254f6cd074f721eada"
  end

  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/7e/84/51e270f1f117da92025427e5cddd71ee62fc65de8b0391568055eb872d3d/anytree-2.12.0.tar.gz"
    sha256 "0dde0365cc8b1f3531e927694f39b903c360eadab2be09c50f3426ecca967949"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "pypdf2" do
    url "https://files.pythonhosted.org/packages/77/d6/afcbdb452c335bccf22ec8ac5ac27b03222f9be8b96043bcce87ba1ce32a/PyPDF2-2.12.1.tar.gz"
    sha256 "e03ef18abcc75da741a0acc1a7749253496887be38cd9887bcce1cee393da45e"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f5/d7/d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1/python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-argparse-plus" do
    url "https://files.pythonhosted.org/packages/9b/34/75eaf9752783aa93498d46ccbc7046e25cc1d44e5f6c43d829d90b9dcd02/rich_argparse_plus-0.3.1.4.tar.gz"
    sha256 "aab9e49b4ba98ff501705678330eda8e9bc07d933edc5cac5f38671ee53f9998"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/a4/2b/d36b6399027bb888faed23e3393f4efc3568996a5c386233b364d9e701d5/yara-python-4.2.3.tar.gz"
    sha256 "31f6f6f2fdca4c5ddfeed7cc6d29afad6af7dc259dde284df2d7ea5ae15ee69a"
  end

  resource "yaralyzer" do
    url "https://files.pythonhosted.org/packages/27/ab/53c0702f351334c1014eff376d67b31e2628197e3ad75a4824c3858512ca/yaralyzer-0.9.3.tar.gz"
    sha256 "d8d2fbb8b12733b3d0623c6de3a7c3ec29dcb040cfdb647bdad811fdf94981a6"
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