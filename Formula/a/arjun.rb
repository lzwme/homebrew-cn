class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https:github.coms0md3vArjun"
  url "https:files.pythonhosted.orgpackagesbb97ed0189286d98aaf92322a06e23b10fc6c298e0ee9a43cd69ab614a1f76cfarjun-2.2.6.tar.gz"
  sha256 "15dbc0abf5efcbbe4ba1892ad8edb08fa5efc41bb2ebaadd0be01e47e70240fc"
  license "AGPL-3.0-only"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8e07304d1647f03c1786b511ff65d3c19d313deb5b314a3219e1b93f9be8a30b"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "dicttoxml" do
    url "https:files.pythonhosted.orgpackageseec93132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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