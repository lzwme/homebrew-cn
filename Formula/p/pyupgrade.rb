class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https:github.comasottilepyupgrade"
  url "https:files.pythonhosted.orgpackages3c714a0ea6653fe4f73d6e7e9353176a383bd7790b3762995dfec5f89d8b5e5dpyupgrade-3.19.0.tar.gz"
  sha256 "7ed4b7d972ed2788c43994f4a24f949d5bf044342992f3b48e1bed0092ddaa01"
  license "MIT"
  head "https:github.comasottilepyupgrade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6bc007370a2d71e68e6125c7da9335bad4b1c3152cd6ed2594c4fdcbf4e2d50"
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