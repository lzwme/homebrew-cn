class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/c9/fb/c289959a98db60787d48150356b8e9519fb5c64f226e2f183408ef8ee3f1/sigma_cli-0.7.10.tar.gz"
  sha256 "6f212e6e571224689e1373c7cdc6c228e49560250e6c5f8233c14a94a0cee8c2"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9b850682be17310ea370d915d63331a178c441a3dfd72c42e87c94b9011e634"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcaf44fe28fd929cd196a02f19f677cff74484cf77b038d582ac6a8df66a004f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc8ebaa7334998bafb1bb2398a144e26b37b629881655c19f836599795f1547"
    sha256 cellar: :any_skip_relocation, sonoma:         "538dd896687df373890442153fab1c0e398397c73f26bed4040061ae40adbcde"
    sha256 cellar: :any_skip_relocation, ventura:        "3e9d873683b01abc3eaf80ec32b2b2638af82a6c34bd77584e5703344a8ffd3d"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9eeb3f36e3b8bfe88ae12f9ea2138dd01db7e59da27a8521b67f5bf4d96b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb31fdd73eb89a6b3b2f325e8ba8fb37a5551528f50326aaa53fa5004cda7b6"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/60/f1/9e62e159f0c461a32d70f25e65918128ac3387225425e5e1091456cac9e7/pysigma-0.10.8.tar.gz"
    sha256 "e8ea313bcfa614d88d7a789d8db03754adcc3259a59ab87a39892000400f7745"
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
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/1c/21f2379555bba50b54e5a965d9274602fe2bada4778343d5385840f7ac34/wcwidth-0.2.10.tar.gz"
    sha256 "390c7454101092a6a5e43baad8f83de615463af459201709556b6e4b1c861f97"
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