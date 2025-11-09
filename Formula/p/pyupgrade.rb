class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https://github.com/asottile/pyupgrade"
  url "https://files.pythonhosted.org/packages/2b/f8/a9dd640cbfc72b4a82d83298c0f3aadc266c89bbb5794363c74231293556/pyupgrade-3.21.1.tar.gz"
  sha256 "436fea5d40cb6adbd2f5102e9be1ec7031b807a03368c9f591a34f51584a7a25"
  license "MIT"
  head "https://github.com/asottile/pyupgrade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6b20c40d49bc99b2f13e3117f937613e4a94fc09f1bc96cbaa82ac5bd981ac3"
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