class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "Identify anything: emails, IP addresses, and more"
  homepage "https:github.combee-sanpyWhat"
  url "https:files.pythonhosted.orgpackagesae3157bb23df3d3474c1e0a0ae207f8571e763018fa064823310a76758eaef81pywhat-5.1.0.tar.gz"
  sha256 "8a6f2b3060f5ce9808802b9ca3eaf91e19c932e4eaa03a4c2e5255d0baad85c4"
  license "MIT"
  revision 1
  head "https:github.combee-sanpyWhat.git", branch: "main"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae683721117722526f328e7e38c2672219a7e0889699cb0d2ae4494c475d1ef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae683721117722526f328e7e38c2672219a7e0889699cb0d2ae4494c475d1ef3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae683721117722526f328e7e38c2672219a7e0889699cb0d2ae4494c475d1ef3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae683721117722526f328e7e38c2672219a7e0889699cb0d2ae4494c475d1ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "ae683721117722526f328e7e38c2672219a7e0889699cb0d2ae4494c475d1ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "ae683721117722526f328e7e38c2672219a7e0889699cb0d2ae4494c475d1ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e184362e5a2a4f936e45251596339088d58eb322223ea0c1fa9cc9e5b582b9d0"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https:files.pythonhosted.orgpackages276fbe940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720eclick-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "commonmark" do
    url "https:files.pythonhosted.orgpackages6048a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages74c3e55ebdd66540503cee29cd3bb18a90bcfd5587a0cf3680173c368be56093rich-10.16.2.tar.gz"
    sha256 "720974689960e06c2efdb54327f8bf0cdbdf4eae4ad73b6c94213cad405c371b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}pywhat 127.0.0.1").strip
  end
end