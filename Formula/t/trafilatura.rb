class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/0d/79/b86cab24322758f3b6e23eb9460741dbe56aca35ee1d226abbb7d9ff8b3d/trafilatura-1.6.4.tar.gz"
  sha256 "97609203089b73be9aa8d1aaaefd5d8dd93e2e92037b0d72f19976af91b18c8a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df801daaae0bbee50da4bca5fac9dd5ba9fb0f6aabc32e89c6842a338ea2e7a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4dc5c6fbb35082eaf5ba919f71465b268ae100880871dd84f9cc5765e1d8ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaff225059006a025fbeeef343f6e6f25df670c0ceafbe8749780616e91f6267"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f291a84cd8c527d214f15bd3ec69971a0d1d25e3b2fb5391eaf90f901fb581c"
    sha256 cellar: :any_skip_relocation, ventura:        "303e1a85e64abec679ee52692e82afaa9077cc0a799fe133d5d0d9f6e0b21b4e"
    sha256 cellar: :any_skip_relocation, monterey:       "2211b7173e20a885ba7a139fa56b2854bb16c3681e6a869ce6f8a2f4c54f91d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa2458b22a41a49310c9b07bd16a1959524dca21b5297da5015e06ab9411c7e"
  end

  depends_on "python-certifi"
  depends_on "python-charset-normalizer"
  depends_on "python-dateutil"
  depends_on "python-lxml"
  depends_on "python-pytz"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/dd/66/09e441e9130ea67201009b3e6020ebccf2c90df4a25a05edd79f08706d33/courlan-0.9.5.tar.gz"
    sha256 "38dc35b2e3bf1f5d516d00d51ac12ebde543e3417c6be6f6a2273c0fc5b5b353"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/78/91/5553678746d5beeb24850994bedaeeb367bc39379523a5dd80312cabc250/htmldate-1.6.1.tar.gz"
    sha256 "3bf0a67ab9d103e183f777e4ffacb6e0b9800f5f117f06cc991aea29c1b07425"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/80/6f/72e69f69ae55a9e7d8a1b1a5c8f809ccc615ca0a16dee2ce0ca48dc32dc9/jusText-3.0.0.tar.gz"
    sha256 "7640e248218795f6be65f6c35fe697325a3280fcb4675d1525bcdff2b86faadf"
  end

  resource "langcodes" do
    url "https://files.pythonhosted.org/packages/5f/ec/9955d772ecac0bdfb5d706d64f185ac68bd0d4092acdc2c5a1882c824369/langcodes-3.3.0.tar.gz"
    sha256 "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end