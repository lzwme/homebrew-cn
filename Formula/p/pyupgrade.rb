class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https://github.com/asottile/pyupgrade"
  url "https://files.pythonhosted.org/packages/cb/11/b08f5e4d50575c944e4ea0a86f070a1ba2c0d5a4dc42fac571a605ada78d/pyupgrade-3.21.0.tar.gz"
  sha256 "3e63a882ec1d16f5621736d938952df3cdc2446501fb049e711415cb8d273960"
  license "MIT"
  head "https://github.com/asottile/pyupgrade.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8fe6a40d022d201b410e6ed96e5a4b0d92637ace5c73f38b1fd48a3151dd34a7"
  end

  depends_on "python@3.14"

  resource "tokenize-rt" do
    url "https://files.pythonhosted.org/packages/69/ed/8f07e893132d5051d86a553e749d5c89b2a4776eb3a579b72ed61f8559ca/tokenize_rt-6.2.0.tar.gz"
    sha256 "8439c042b330c553fdbe1758e4a05c0ed460dbbbb24a606f11f0dee75da4cad6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      print(("foo"))
    PYTHON

    system bin/"pyupgrade", "--exit-zero-even-if-changed", testpath/"test.py"
    assert_match "print(\"foo\")", (testpath/"test.py").read
  end
end