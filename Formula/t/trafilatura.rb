class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/a5/81/f7818b3d805427e8448429fd1bfc126a06b2e5daa58ea97a8b153e5454fb/trafilatura-1.6.2.tar.gz"
  sha256 "a984630ad9c54d9fe803555d00f5a028ca65c766ce89bfd87d976f561c55b503"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f57e59608df16b900dfc05df39567197c6eadd6497283a6bb10637b12ff4ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49630e272857ff3cf82214507859cf7e0e8f60c847383d9e0eb340abfad19f47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b063e6cad8caaa9994a5205212fc19a5134bb60e9444737f5d06b80f7fb9ac3"
    sha256 cellar: :any_skip_relocation, sonoma:         "61d8a677da50482d548ab9845347205838797d3c386c9a760d251c93493ceb9d"
    sha256 cellar: :any_skip_relocation, ventura:        "81a5a37407867c003828e6af278e844a84b10b7f05e304cc37062732486f2491"
    sha256 cellar: :any_skip_relocation, monterey:       "4a277a32be0d19e35a77e359cf3ef9cdb05c8da70fe48d1e241bba26c9808980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63ead097c3711a225bb925511e2170bdeb10063d304159fa40115d47cb3f369"
  end

  depends_on "python-certifi"
  depends_on "python-lxml"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

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

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
    sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Search\nImages\nMaps\nPlay", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end