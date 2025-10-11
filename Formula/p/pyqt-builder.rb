class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/f7/25/e8ad047efd873e07139f703b681017fa0c3326540cc4f42b02e1a237a3b0/pyqt_builder-1.19.0.tar.gz"
  sha256 "79540e001c476bc050180db00fffcb1e9fa74544d95c148e48ad6117e49d6ea2"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecb3ab6150a30afc271533397f6f3daecbad3cb44be32f6af40c33ed8f270309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb3ab6150a30afc271533397f6f3daecbad3cb44be32f6af40c33ed8f270309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb3ab6150a30afc271533397f6f3daecbad3cb44be32f6af40c33ed8f270309"
    sha256 cellar: :any_skip_relocation, sonoma:        "221e5b93af5b4c81ff30210a15c34afc19cfdfd2bef0fbbc79deef56a5543abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "221e5b93af5b4c81ff30210a15c34afc19cfdfd2bef0fbbc79deef56a5543abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221e5b93af5b4c81ff30210a15c34afc19cfdfd2bef0fbbc79deef56a5543abd"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/48/a0/c725bf92945a95e6aee2a07f26f7f33ee2720a06bdd06b2e5692075bd761/sip-6.13.1.tar.gz"
    sha256 "d065b74eca996f29f1f0831ad321efaecf9906759b09466edc45349df7be6cd0"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_install_with_resources

    # Modify the path sip-install writes in scripts as we install into a
    # virtualenv but expect dependents to run with path to Python formula
    inreplace venv.site_packages/"sipbuild/builder.py", /\bsys\.executable\b/, "\"#{which(python3)}\""
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system libexec/"bin/python", "-c", "import pyqtbuild"
  end
end