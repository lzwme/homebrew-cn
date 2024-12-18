class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https:github.comasottilepyupgrade"
  url "https:files.pythonhosted.orgpackages353aefa8e75cf84d53f1b3f0113387ab120ef460396a4068e41b6cf18a3d216dpyupgrade-3.19.1.tar.gz"
  sha256 "d10e8c5f54b8327211828769e98d95d95e4715de632a3414f1eef3f51357b9e2"
  license "MIT"
  head "https:github.comasottilepyupgrade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7a603075222ee69b22abf8d0cca0d665197f3bc0e330e4cf0990c7e18b41c0de"
  end

  depends_on "python@3.13"

  resource "tokenize-rt" do
    url "https:files.pythonhosted.orgpackages6b0a5854d8ced8c1e00193d1353d13db82d7f813f99bd5dcb776ce3e2a4c0d19tokenize_rt-6.1.0.tar.gz"
    sha256 "e8ee836616c0877ab7c7b54776d2fefcc3bde714449a206762425ae114b53c86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write <<~PYTHON
      print(("foo"))
    PYTHON

    system bin"pyupgrade", "--exit-zero-even-if-changed", testpath"test.py"
    assert_match "print(\"foo\")", (testpath"test.py").read
  end
end