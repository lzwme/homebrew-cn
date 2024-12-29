class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https:pyqt-builder.readthedocs.io"
  url "https:files.pythonhosted.orgpackages4d07da6140518dea6cf99b5dd5eac928f93813d7b2dd9f42ff9c193421d2b171pyqt_builder-1.17.1.tar.gz"
  sha256 "457dcd6a1408ea4bf1264e3511c734d53451ae8a3905e98982d50f7b3fdab724"
  license "BSD-2-Clause"
  head "https:github.comPython-PyQtPyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f24de17421e9583c5174d88770393b7ca16459e05e678a537162754455c8b157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f24de17421e9583c5174d88770393b7ca16459e05e678a537162754455c8b157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f24de17421e9583c5174d88770393b7ca16459e05e678a537162754455c8b157"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdd039f3908f55155929be37eaedf8afb4a2cf9ca0d200569f5af48dfe27f9ee"
    sha256 cellar: :any_skip_relocation, ventura:       "fdd039f3908f55155929be37eaedf8afb4a2cf9ca0d200569f5af48dfe27f9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1d12a34b4d18478b572247c2f1108abffaf7e01aa1cf4e60ac77e38f73f605"
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
    url "https:files.pythonhosted.orgpackagese283b23f610ef99fa23aa3c8dcd2ff8536c37b943654405ff4f45f3230327a40sip-6.9.1.tar.gz"
    sha256 "7904be5190d7879952563b78a3af0e58fa27d9525af7f53f93eac7a83b433e7b"
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