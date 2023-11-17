class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.bezdomni.net/"
  url "https://files.pythonhosted.org/packages/29/b0/1b060f39a1dd274d0708dd39420e550b6c8e21cf946651d6212470625a82/toot-0.38.2.tar.gz"
  sha256 "4b507cfa8359de0e186ff7a14fbfe3972f51b65757b0c8366d827f4d2d230f68"
  license "GPL-3.0-only"
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dda6c50bb7779486cfc3cc8d722920fbb3d66c28c479efc24d7426995f660e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9b18704c46f54e152c1948a89f8e79131b31a238a9247bbf5087320afbd1893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bb016a7df6c4ae07da7c2ee98364a9af2a72e02848225e5ba1d7895c99051e"
    sha256 cellar: :any_skip_relocation, sonoma:         "aeabd9874495a0afac590562905e137fb134fa33a6b719d27938f7b5e4b7e2cc"
    sha256 cellar: :any_skip_relocation, ventura:        "f676dc8a7939a23a23d03df4f6d09775c29fc25cf8e8dece2e462dd9ebfab7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "25d3fb90e91e6f1362bd00fe6d159d29c9e724a66749224dbdae83b28b6075ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a838a3f3f7189cc7d3e03a74fa74cd352409e53f9da480a974902076590e68"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/81/f4/fa6da5de99e11e60d826567609eaa815146f835285a26f6c0f61e6015e2c/urwid-2.2.3.tar.gz"
    sha256 "e4516d55dcee6bd012b3e72a10c75f2866c63a740f0ec4e1ada05c1e1cc02e34"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/1c/21f2379555bba50b54e5a965d9274602fe2bada4778343d5385840f7ac34/wcwidth-0.2.10.tar.gz"
    sha256 "390c7454101092a6a5e43baad8f83de615463af459201709556b6e4b1c861f97"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot")
    assert_match "You are not logged in to any accounts", shell_output("#{bin}/toot auth")
  end
end