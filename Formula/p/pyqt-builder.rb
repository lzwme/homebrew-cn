class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/42/90/0aed537919f08cc5bd96e0ad2dc280766f578785ce82a7fa0e6abd22ba17/pyqt_builder-1.20.0.tar.gz"
  sha256 "267ac1ee1593c67884f3c9cb6566f72a92ca28353050fc9d087433c28c74a889"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "238b6f45e514ec8748f2c1f8d75e23baa3fb1fea41fcf27c59ac94e4403d17c7"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/0d/d6/4108ef066e4a8452b393d5acd03fed176d7178c0512b2ecf564dc8dcf796/sip-6.17.1.tar.gz"
    sha256 "34e2c1389e25394f5ba3c6b9d999d04373baf8d7161410536d444f48226d2f50"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{python3}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end