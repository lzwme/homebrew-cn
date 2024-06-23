class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https:pyqt-builder.readthedocs.io"
  url "https:files.pythonhosted.orgpackagesf0739e2755469405520b38162a4f594db1e0a28e2d29ab367acba1cd3c0783b5pyqt_builder-1.16.3.tar.gz"
  sha256 "3ce5c03dc3fc856b782da3f53b4f3f3b6556aad7bd8416d7bbfc274d03bcf032"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https:github.comPython-PyQtPyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27a3e3783db9fd3777fad2e41e5229e9f360c9cc114dd22addd8d096c60725c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27a3e3783db9fd3777fad2e41e5229e9f360c9cc114dd22addd8d096c60725c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27a3e3783db9fd3777fad2e41e5229e9f360c9cc114dd22addd8d096c60725c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d15a1270ba725b24532ed1985d08fc38c3f827318ea96f6a7a6744bd778637e"
    sha256 cellar: :any_skip_relocation, ventura:        "1d15a1270ba725b24532ed1985d08fc38c3f827318ea96f6a7a6744bd778637e"
    sha256 cellar: :any_skip_relocation, monterey:       "1d15a1270ba725b24532ed1985d08fc38c3f827318ea96f6a7a6744bd778637e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a509ee40f702fcc7964ce321862a021bb76a8674a52c63db2ba9c897e432cf2a"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages1c1c8a56622f2fc9ebb0df743373ef1a96c8e20410350d12f44ef03c588318c3setuptools-70.1.0.tar.gz"
    sha256 "01a1e793faa5bd89abc851fa15d0a0db26f160890c7102cd8dce643e886b47f5"
  end

  resource "sip" do
    url "https:files.pythonhosted.orgpackages9faa8c767fc6521fa69a0632d155dc6dad82ecbd522475d60caaefb444f98abcsip-6.8.4.tar.gz"
    sha256 "c8f4032f656de3fedbf81243cdbc9e9fd4064945b8c6961eaa81f03cd88554cb"
  end

  def install
    python3 = "python3.12"
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