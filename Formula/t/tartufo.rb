class Tartufo < Formula
  include Language::Python::Virtualenv

  desc "Searches through git repositories for high entropy strings and secrets"
  homepage "https:tartufo.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackagesd5ea6248387282150270f1886d75111f776f43e694f488a3a1ea3b5b0d1195f1tartufo-5.0.0.tar.gz"
  sha256 "99ab6652cae6de295aeb31089e9ba27d66d0ad695af493d2d5cbc795397d1c84"
  license "GPL-2.0-only"
  revision 1
  head "https:github.comgodaddytartufo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f684681220701497493bea2b2d354bb77e2cb48891b00ebfb030a3c8883c951"
    sha256 cellar: :any,                 arm64_ventura:  "71d7ecb5b71477b306f02efd53807ef08cd5987908d55fa06ed1f38732f025f8"
    sha256 cellar: :any,                 arm64_monterey: "7ae51faea90a2ee86ab0ebce6a260c07885d8839cf36cbf52168826ebe12c2ab"
    sha256 cellar: :any,                 sonoma:         "f3b6f6d7f1a99ad94a9e00bf7b09fe6d6c8b2989f1e7e950d17f00261bf034ca"
    sha256 cellar: :any,                 ventura:        "a31b499051c106bf60e14253d03f91861da3b414a24e178d91d3208b9733cbba"
    sha256 cellar: :any,                 monterey:       "78fae9022fb120fb5f605c8ef57a69d604857b37dbacc6386158d5521b91c8f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f73241c51a2ce44fa61e4553d42f7dd99382692b83033d743f98012a0b7b7db9"
  end

  depends_on "libgit2"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages612cd21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https:files.pythonhosted.orgpackagesf05e6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bfpygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages1037dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978aftomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tartufo --version")

    output = shell_output("#{bin}tartufo scan-remote-repo https:github.comgodaddytartufo.git")
    assert_match "All clear. No secrets detected.", output
  end
end