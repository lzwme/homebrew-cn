class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/69/f1/ef1c069d97cc8b7404aa0588be1fc6b02b9d2b1997bdd1587687394fb8c9/sigma_cli-0.7.8.tar.gz"
  sha256 "bf62f5f65c94e55ab62dd2800a5ba2b46cfdfcbc82c04ec107cf9e5e3a1a46bf"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec6f5987f308a5314696ca007e90e0b66fabc1a07d65ca0866395523b5d45b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f266f59631e91a5004bb3f4931fc83678cedd7587354aa96e0ca0c4357ea68a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75451f891c24ed11e6caff81f9185348835757f7ce45a817350e370e24369091"
    sha256 cellar: :any_skip_relocation, sonoma:         "dadbd96d0f95ac400e1ca78de3ffaea68f94329be2ce231aca27cf9bb46c22b1"
    sha256 cellar: :any_skip_relocation, ventura:        "bbb849da7826cfd3bdbbe806259296814e661d9eedbb3561128c9f3d3578f534"
    sha256 cellar: :any_skip_relocation, monterey:       "041cc256e57168ef384977d065e1704b04ff16fa65391ebee56cd310a3f1e6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d23a93ca46fce7638d8be22d5e612b2d35b40a75d46de9f8a9653d21bf706e"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/cd/76/ce641f52a56e55ab9b239c031e8e924d2d8042f53eb2705d0d0f6205658d/pysigma-0.10.6.tar.gz"
    sha256 "f1deb0c5e9d90cba75821bdc21bfad8d47babac4fa7c4495dc213255fbe89b82"
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/b6/13/144274ca0f2d721e79360e309b062a3a765cecdc87c03d2a893430e00454/pysigma_backend_sqlite-0.1.0.tar.gz"
    sha256 "0ff6f8029a5e4de7d31e30916f073f23422091da5e204653ac7272483f513521"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/a6/ad/428bc4ff924e66365c96994873e09a17bb5e8a1228be6e8d185bc2a11de9/wcwidth-0.2.9.tar.gz"
    sha256 "a675d1a4a2d24ef67096a04b85b02deeecd8e226f57b5e3a72dbb9ed99d27da8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin install sqlite")
    assert_match "Successfully installed plugin 'sqlite'", output
  end
end