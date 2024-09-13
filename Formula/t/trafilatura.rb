class Trafilatura < Formula
  include Language::Python::Virtualenv

  desc "Discovery, extraction and processing for Web text"
  homepage "https://trafilatura.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/d0/cd/77e4403b61d5da59063bb65ee894cf951c6f1137658499947adc040102f5/trafilatura-1.12.2.tar.gz"
  sha256 "4c9cb1434f7e13ef0b16cb44ee1d44e84523ec7268940b9559c374e7effc9a96"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "63161177f3f7c42fcb6fb840115af4d68fcfba6b43001d0b31558130ad1a13ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebad8827a170c20b970a27b10d11faedefade5aec9522f795c76e9434c0dd9ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5584944e82447b1cb0942891d08559b59d7c80701c53cab67fedfefaada56b1"
    sha256 cellar: :any,                 arm64_monterey: "2cef65fa51b04411aa697fd839b12dd03b3820af08fd4d5bc7c26320f1dcfd29"
    sha256 cellar: :any_skip_relocation, sonoma:         "99fcf7529e979a40dbd48df3900c9cb2c337454e3e1dcd722421703496aea506"
    sha256 cellar: :any_skip_relocation, ventura:        "31dc173a376775e205a111c5de50f27f432d59a1a51b96a5379ed333c8acc731"
    sha256 cellar: :any,                 monterey:       "6104a04dae5551a8a6e1538593b0c37e20c0e32d81153958c2ce7fa7d86a53bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1bd700be1cf8c9710c9634605e241b2974d6ea2744aac06223c80fa05797f09"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "babel" do
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "courlan" do
    url "https://files.pythonhosted.org/packages/9f/d4/50ac3848147e1c74d8f207064093dc2a62b8f51e0f615f7ba5cf5fd732f7/courlan-1.3.1.tar.gz"
    sha256 "10858ab686470a3b1d8748d7b88199607c94e74eba3c8ade759ba4a9576d366e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/1a/b2/f6b29ab17d7959eb1a0a5c64f5011dc85051ad4e25e401cbddcc515db00f/dateparser-1.2.0.tar.gz"
    sha256 "7975b43a4222283e0ae15be7b4999d08c9a70e2d378ac87385b1ccf2cffbbb30"
  end

  resource "htmldate" do
    url "https://files.pythonhosted.org/packages/e2/22/7df1ee5f04210469776fbf992ee826a5da8ec9f0fd6819d01ac3f78d83d4/htmldate-1.9.0.tar.gz"
    sha256 "90bc3c66cbb49be21888f54b9a20c0b6739497399a87789e64247fc4e04c292f"
  end

  resource "justext" do
    url "https://files.pythonhosted.org/packages/b1/59/93ce612fce25c274efc88ec4d65963ce80fce96b9048e9fc1e430d893a9e/justext-3.0.1.tar.gz"
    sha256 "b6ed2fb6c5d21618e2e34b2295c4edfc0bcece3bd549ed5c8ef5a8d20f0b3451"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/ef/b7/407da72fcd7b92fc4f41f3b8e94a733b2deae061d6d4ccf26d2c86dc1d42/lxml_html_clean-0.2.2.tar.gz"
    sha256 "cc34178e34673025c49c3d7f4bd48754e9e4b23875df2308f43c21733d8437fb"
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
    url "https://files.pythonhosted.org/packages/3f/51/64256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478/regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
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
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trafilatura --version")

    assert_match "Google", shell_output("#{bin}/trafilatura -u https://www.google.com")
  end
end