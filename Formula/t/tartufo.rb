class Tartufo < Formula
  include Language::Python::Virtualenv

  desc "Searches through git repositories for high entropy strings and secrets"
  homepage "https:tartufo.readthedocs.ioenstable"
  url "https:files.pythonhosted.orgpackagesd5ea6248387282150270f1886d75111f776f43e694f488a3a1ea3b5b0d1195f1tartufo-5.0.0.tar.gz"
  sha256 "99ab6652cae6de295aeb31089e9ba27d66d0ad695af493d2d5cbc795397d1c84"
  license "GPL-2.0-only"
  revision 3
  head "https:github.comgodaddytartufo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b2dde8f4519f9279df16776e0d8980b89b44c4b94925b6539bc42fb734fdaeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b2dde8f4519f9279df16776e0d8980b89b44c4b94925b6539bc42fb734fdaeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b2dde8f4519f9279df16776e0d8980b89b44c4b94925b6539bc42fb734fdaeb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0622862e7b007ad202e55a94c7f2bef2ad6314afae83a74d976525f7f89c8871"
    sha256 cellar: :any_skip_relocation, ventura:        "0622862e7b007ad202e55a94c7f2bef2ad6314afae83a74d976525f7f89c8871"
    sha256 cellar: :any_skip_relocation, monterey:       "0622862e7b007ad202e55a94c7f2bef2ad6314afae83a74d976525f7f89c8871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94090ab1f2288440f1bc42dfd41e009e90272bfbc67af83077052f215cfb3791"
  end

  depends_on "pygit2"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages612cd21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
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

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages1037dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978aftomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  # pygit 1.15.1 build patch, upstream pr ref, https:github.comgodaddytartufopull532
  patch do
    url "https:github.comgodaddytartufocommitc4fe2cb4011c3f830945f20593df81adfd4bcf17.patch?full_index=1"
    sha256 "45d63c2c3bef7c11ffd37020f1b4e0276a930a212ca596de44b86807ff8eb062"
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