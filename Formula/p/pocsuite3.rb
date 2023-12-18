class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https:pocsuite.org"
  url "https:files.pythonhosted.orgpackages0ca089e1eb8bd85cdf54b0c642d22ea8b39d7f47769b116a9181367383d5f2d2pocsuite3-2.0.5.tar.gz"
  sha256 "17ba73665e225225299570d97654eac3ded6cdf761ca42e57353dd6615bf496f"
  license "GPL-2.0-only"
  head "https:github.comknownsecpocsuite3.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac47fec9e282648aa8334c2d09e45c5e5c9b6fc86b866a9501cb10bd3c6835bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bbee2d14cc225ecbab311cab59cfaf87453c26b27ee87100b9c964787e62cfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cde531e43703dada681a16c70ceb78188338856909880f037286512e6a37af24"
    sha256 cellar: :any_skip_relocation, sonoma:         "4abdd7275e36d41af71d68c1dc23186d2e3858a9ab49434766c5721bb6131536"
    sha256 cellar: :any_skip_relocation, ventura:        "7135616e2e9904cc2a11637cdd18e8fd06fca9f2297564cedf0bce9374f06e52"
    sha256 cellar: :any_skip_relocation, monterey:       "05ed269122dcfb7ed917a402d80c9d5086576f9ad80c01f002aa20defae54d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b5441743b5c759a2edafafee5db168bc0222f0c3bb10edb6b45016a93d74e6"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackages786b4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "dacite" do
    url "https:files.pythonhosted.orgpackages6f6df7ee0f5410665cdfbd56d0caf5da9217410348e5a0c11d3e6cfe1c1ddd7adacite-1.8.0.tar.gz"
    sha256 "6257a5e505b61a8cafee7ef3ad08cf32ee9b885718f42395d017e0a9b4c6af65"
  end

  resource "faker" do
    url "https:files.pythonhosted.orgpackages92f0723ced020051d06e6539a450577a4064127d1f30dc380d71f9a46dd40f95Faker-19.11.0.tar.gz"
    sha256 "a62a3fd3bfa3122d4f57dfa26a1cc37d76751a76c8ddd63cf9d24078c57913a4"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jq" do
    url "https:files.pythonhosted.orgpackages2250ab53cc23eddad14a28920e95523b9f39849d9e3139836ec8fcbb7e8e3517jq-1.6.0.tar.gz"
    sha256 "c7711f0c913a826a00990736efa6ffc285f8ef433414516bb14b7df971d6c1ea"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackagese1c05e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386bprettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages14c909d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesbedf75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aefpyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "scapy" do
    url "https:files.pythonhosted.orgpackages67a12a60d5b6f0fed297dd0c0311c887d5e8a30ba1250506585b897e5a662f4cscapy-2.5.0.tar.gz"
    sha256 "5b260c2b754fd8d409ba83ee7aee294ecdbb2c235f9f78fe90bc11cb6e5debc2"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackagesb885147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444ctermcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagescbee20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04bawcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}pocsuite -k ecshop --options")
  end
end