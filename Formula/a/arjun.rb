class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https:github.coms0md3vArjun"
  url "https:files.pythonhosted.orgpackagesbb97ed0189286d98aaf92322a06e23b10fc6c298e0ee9a43cd69ab614a1f76cfarjun-2.2.6.tar.gz"
  sha256 "15dbc0abf5efcbbe4ba1892ad8edb08fa5efc41bb2ebaadd0be01e47e70240fc"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cee8d9a1bac393738ac553f66c5e877a83d4003e1ac29bfa0d1edf67d48e5851"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dicttoxml" do
    url "https:files.pythonhosted.orgpackageseec93132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "ratelimit" do
    url "https:files.pythonhosted.orgpackagesab38ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dbfile = libexecLanguage::Python.site_packages(python3)"arjundbsmall.txt"
    output = shell_output("#{bin}arjun -u https:mockbin.org -m GET -w #{dbfile}")
    assert_match "No parameters were discovered", output
  end
end