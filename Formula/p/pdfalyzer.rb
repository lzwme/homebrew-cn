class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https:github.commichelcrypt4d4muspdfalyzer"
  url "https:files.pythonhosted.orgpackages0ab57448e055f672565654e07658fd5dad471d92542ae76a06d844d45f696503pdfalyzer-1.15.1.tar.gz"
  sha256 "285bb60026c54a68215c795dc4809fed0f7640ae51796f411dbf80afb0ed486b"
  license "GPL-3.0-or-later"
  head "https:github.commichelcrypt4d4muspdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "769a7f3e5d2bb0c4b03eac205437a0ae39d6c06de36e30b68bb5952bc886098b"
    sha256 cellar: :any,                 arm64_ventura:  "7c0c18a35de44b5dfb9f1e913d8451b48fe1232a36d67c3e13f0524ae442d8aa"
    sha256 cellar: :any,                 arm64_monterey: "fbeed5a920cd5278398252fd1ff8761bdcec1c3125dca545521d37837acfaf18"
    sha256 cellar: :any,                 sonoma:         "18d4d0f43361089bf478521663063e1b15334c03ca81b6a375025473dae110f4"
    sha256 cellar: :any,                 ventura:        "94f09ecf0ca2ef12d2499608f23fb03f61ecc04267abfa1704ff60e01f3ed8a6"
    sha256 cellar: :any,                 monterey:       "163edfe4ca76a679d4df476f44366910a310e412d8cb634c7c690ee7d23e2f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25f8d4f994fb53fb7a47706be636ae35112389e05862393d2bb42c07c4e09b1"
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

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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

  resource "yara-python" do
    url "https:files.pythonhosted.orgpackages2f3a0d2970e76215ab7a835ebf06ba0015f98a9d8e11b9969e60f1ca63f04ba5yara_python-4.5.1.tar.gz"
    sha256 "52ab24422b021ae648be3de25090cbf9e6c6caa20488f498860d07f7be397930"
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