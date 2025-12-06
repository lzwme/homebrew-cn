class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://pyqt-builder.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/61/f6/f3b504b4d55a7c4d3393cb90378501f1f5fc7f233bd85c0375674f84d2af/pyqt_builder-1.19.1.tar.gz"
  sha256 "6af6646ba29668751b039bfdced51642cb510e300796b58a4d68b7f956a024d8"
  license "BSD-2-Clause"
  head "https://github.com/Python-PyQt/PyQt-builder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ab06eaad9e2b670a52a0e57317557df1c72c9771a11120b8294d9f85a8d42b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ab06eaad9e2b670a52a0e57317557df1c72c9771a11120b8294d9f85a8d42b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07ab06eaad9e2b670a52a0e57317557df1c72c9771a11120b8294d9f85a8d42b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb6e43b07a4ef29e83828b189082444da152310ceaa37ce7e53be2283700828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb6e43b07a4ef29e83828b189082444da152310ceaa37ce7e53be2283700828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb6e43b07a4ef29e83828b189082444da152310ceaa37ce7e53be2283700828"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sip" do
    url "https://files.pythonhosted.org/packages/a7/8a/869417bc2ea45a29bc6ed4ee82757e472f0c7490cf5b7ddb82b70806bce4/sip-6.14.0.tar.gz"
    sha256 "20c086aba387707b34cf47fd96d1a978d01e2b95807e86f8aaa960081f163b28"
  end

  def python3
    "python3.14"
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