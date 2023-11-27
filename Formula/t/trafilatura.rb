class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a5/81/f7818b3d805427e8448429fd1bfc126a06b2e5daa58ea97a8b153e5454fb/trafilatura-1.6.2.tar.gz"
  sha256 "a984630ad9c54d9fe803555d00f5a028ca65c766ce89bfd87d976f561c55b503"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0ce8400dabe8866ce6bf41eade61e7b300a1d3dfc04f5ca000d00296680eca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77ff886350f79c1cc4a652681875e7fa645066d90c25493b7269c3405af66262"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5e1e6fad1aa03fea77830ac75bcdfc210067bbd66a969efc415ad455af9788a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b895d654138d38fc997b2e096d186c366d2f5d839072b8236ec55b886b0d7e86"
    sha256 cellar: :any_skip_relocation, ventura:        "c7f3bec5cbde0e23640ee8573de253521675c526555e082156daeed70153ec9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a2a3750c3a033201e7a5a43851f49e7f10d5024c7731428d784518b671079b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9f477006d9c4307fa420279dee084865c2b8821aea44f4f2c96b4f57476952"
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
    url "https://files.pythonhosted.org/packages/53/35/d141b5ffc381cef94c95d32d7082aff443cfea22b2a75c2839297064d408/courlan-0.9.4.tar.gz"
    sha256 "6906aa9a15ae9d442821e06ae153c60f385cff41a8d44b9597c00b349f7043c5"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/7e/16/e95f1d2f8014bac38e00d037e192222e52de7db7c71268ed3b2e12d4893c/dateparser-1.1.8.tar.gz"
    sha256 "86b8b7517efcc558f085a142cdb7620f0921543fcabdb538c8a4c4001d8178e3"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/e4/81/b3b8c88bbb6cdf610098597b7b96d71151de4bc8bda456e882da0486a92d/htmldate-1.5.2.tar.gz"
    sha256 "cc8b41c412b21d8a9236981755cfba7dfe25ebaf925a46417058d4902ad77e9b"
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
    url "https://files.pythonhosted.org/packages/b2/e2/adf17c75bab9b33e7f392b063468d50e513b2921bbae7343eb3728e0bc0a/tzlocal-5.1.tar.gz"
    sha256 "a5ccb2365b295ed964e0a98ad076fe10c495591e75505d34f154d60a7f1ed722"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end