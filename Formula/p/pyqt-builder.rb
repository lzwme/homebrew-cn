class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https:pyqt-builder.readthedocs.io"
  url "https:files.pythonhosted.orgpackages0478ec38b8fa8f44d7437cc4b1930669d50baebb3c43c16d0a65c5b487fa2d12pyqt_builder-1.17.0.tar.gz"
  sha256 "fce0e92346d2a4296525b7ad9f02b74ea425f26210390ae0d3e4ca08c31cf4cc"
  license "BSD-2-Clause"
  head "https:github.comPython-PyQtPyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a305cfb1583442d715fbee7606572ea129e7a1b61d9e775243ac0324ed0cd9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a305cfb1583442d715fbee7606572ea129e7a1b61d9e775243ac0324ed0cd9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a305cfb1583442d715fbee7606572ea129e7a1b61d9e775243ac0324ed0cd9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "97bd0c50964d730b4ddb3a9da59114c0925ed9391702456e5834356e9d6b8897"
    sha256 cellar: :any_skip_relocation, ventura:       "97bd0c50964d730b4ddb3a9da59114c0925ed9391702456e5834356e9d6b8897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aac0a8b6348dbc399bc5e812e4d0dcdbf24fd22e159a0c8dae95488d41323b3"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "sip" do
    url "https:files.pythonhosted.orgpackagesb8dc17b69b375103aa3db633b3f1f46bf7030cbe516b2b6d5dc73b7668a7840dsip-6.9.0.tar.gz"
    sha256 "093fd0e15d99ae2f8a83dd7f7dbaa3ff250c582a77eb8e0845cd9acadb1f0934"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages"sipbuildbuilder.py", \bsys\.executable\b, "\"#{which(python3)}\""
  end

  test do
    system bin"pyqt-bundle", "-V"
    system libexec"binpython", "-c", "import pyqtbuild"
  end
end