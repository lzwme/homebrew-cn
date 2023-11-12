class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/f9/62/7a5d20b138a41799477ef4b5d2b199feb19c3ab627ecfba369e4c2dbb4cf/sigma_cli-0.7.9.tar.gz"
  sha256 "2f8385bb4f647214df67f88405e9a4fd029ebf32fc3960b45efb03ffb7466183"
  license "LGPL-2.1-or-later"
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad007f0a43e138abe3421fc6289719ecd93d48856f576ab960487c407854e26b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12487fb40369bf19ffbb9d7266a9c2d77bcc76bd855b1b05837f459c872869ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fbae47d78042e7d1d0fa3442dfca7ed36b61e2d3f80081025d4fce2561e8679"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7f00a2d724563390f09c3bc60850ebf8bf869f87a0dc793f2df07439d60c2d7"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd7a89ee7321fc2559668c9e7d2b6c7852df24bacab48620ca328fdd1cc9fec"
    sha256 cellar: :any_skip_relocation, monterey:       "c6d453684f3785d5df0f52e297e8b64b61b880920a9dfd9046043119a09ba072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05b0197e14664648a795c27468f516a31e492e82513636fc181407c23505c3a3"
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