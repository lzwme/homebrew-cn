class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/83/2d/e521035e38c81c9d7f4aa02a287dddeb163ad51ebca28bef7563fc503c07/arjun-2.2.2.tar.gz"
  sha256 "3b2235144e91466b14474ab0cad1bcff6fb1313edb943a690c64ed0ff995cc46"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "192f7ae94916acd47d28413c5abeb492a1642c1b059c1093c1e95cd62e87a073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cd188c43e6f7b0e2b301c00d68da0ee61719941e239e75a176853800701322"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f112f1ad2d0a9d64ce41d87d1e664c3d601de97cde3de6146e13ef8202adae6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bee8fadcac1d7c77cce0e80c8cd0a9fc11f74180a1fd7522c789c0e14020d55c"
    sha256 cellar: :any_skip_relocation, ventura:        "a194a2368caa2bbf92f53635712e27c427b853f3f7242e8f7f0f1231b53c5d55"
    sha256 cellar: :any_skip_relocation, monterey:       "d925de5da66003db36f3e7b2414cea411c34bc28189cab5ccb4f87db076a295c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb9e5a170f2cda7983d63b6f598c7dd2106f81091360dd905aa7a064ea3b97b7"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end