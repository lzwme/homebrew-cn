class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/aa/2d/e91ca57ca6ead5bf72e2c651fc81d47052c4c794a27d729598fba90404b4/trafilatura-1.6.3.tar.gz"
  sha256 "671dd6e0000e101c4bce8d70f4408bcb79fcbf2275ee25591efe33e2c8a1600d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce1f417092b1bb44cebe2246a298f0f047c582ae3e28eebf6b6a78d4a64d9eff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64f4462e7a1d54617d58c65858755370d5bbd994c66adf4bfb9952d6dc50213a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d0c5a9daadb723bb5d6a4b9f7e2f2282303c812955f25184cf96b4ccdb82b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc7b6f91fb0412e9f90e5a64e1fda276076b0e4caaad172d3c7381212576cbe5"
    sha256 cellar: :any_skip_relocation, ventura:        "742652676096d33ef7e4e415cf2e52baf913c4c076b54f99d74a3973c54d9e42"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f0754016997d369676380e5c3f2985fa3c35fb25f1aee0934ac99bbfe9e8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d33ebf460b091362c9ae2d45f9590a059e797e85a5bb2941986f99e7dd5269d7"
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
    url "https://files.pythonhosted.org/packages/24/fb/26213bb6300dd7d17afb131d222b4f7e083d822d0fd72089eb60e3b134c1/htmldate-1.6.0.tar.gz"
    sha256 "5827c8f626a16800a29e57e8188a3d32d0b08ca4c7bd662537b73bbbf22c45a6"
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
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
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