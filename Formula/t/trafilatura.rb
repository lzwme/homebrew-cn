class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9d/2f/89e53764a5ac7da412b0ca09646c3cfd1e1be5631bd8ca4810b92b571227/trafilatura-1.8.1.tar.gz"
  sha256 "6b878dfdbd5c5dfb55d0f8307f2b7dc15ac3458054f74861ff98a172f5e38720"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddbdac108f9f7741b82d013217aeb7b6c0fc53df6596c93010adaf6b82f20cd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b9f7980e837f6dad549cf78d373517d815b7ce579152835ef67a2d5354ee5c9"
    sha256 cellar: :any,                 arm64_monterey: "007419638e014bcb8be0631e9820691d9c80e20ad9aecf645e709622b70e2aa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac5b9ed571505f9b4476f8380dd5976629a1b375c5ac9880b7c79805abd84f31"
    sha256 cellar: :any_skip_relocation, ventura:        "2915682b614ca7e816354dad5d6e3673fb9a04968674fda5d77348996f7e869e"
    sha256 cellar: :any,                 monterey:       "9e8a7b35d7b1ad72b9a009169bf17545a1df2db1906dc2b65a25f4a393e7b1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66de37a0fae8757a977ff499660a42e87667be0fd1ed7cbefd8e4554adc57e7c"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/69/df/790707a410bb4381609a21d89d11accd5c7d610a2f8a8d315bbd978f2cbe/courlan-1.0.0.tar.gz"
    sha256 "3c35511c36525cb2f941cd6709b7a3a742ed95f0b9e56c97eec0c16fdc035183"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/25/e9/59e50717268787d847064ee9b68da213f8ee8f56370e5232de4bbaa2a854/htmldate-1.8.0.tar.gz"
    sha256 "f94c7d017f42a1cf422e5a7c5ef10cacbae276886314f27a986464627f30bb15"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/80/6f/72e69f69ae55a9e7d8a1b1a5c8f809ccc615ca0a16dee2ce0ca48dc32dc9/jusText-3.0.0.tar.gz"
    sha256 "7640e248218795f6be65f6c35fe697325a3280fcb4675d1525bcdff2b86faadf"
  end

  resource "langcodes" do
    url "https://files.pythonhosted.org/packages/5f/ec/9955d772ecac0bdfb5d706d64f185ac68bd0d4092acdc2c5a1882c824369/langcodes-3.3.0.tar.gz"
    sha256 "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/73/a6/0730ff6cbb87e42e1329a486fe4ccbd3f8f728cb629c2671b0d093a85918/lxml-5.1.1.tar.gz"
    sha256 "42a8aa957e98bd8b884a8142175ec24ce4ef0a57760e8879f193bfe64b757ca9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end