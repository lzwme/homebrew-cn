class Pytest < Formula
  include Language::Python::Virtualenv

  desc "Simple powerful testing with Python"
  homepage "https://docs.pytest.org/en/latest/"
  url "https://files.pythonhosted.org/packages/fb/aa/405082ce2749be5398045152251ac69c0f3578c7077efc53431303af97ce/pytest-8.4.0.tar.gz"
  sha256 "14d920b48472ea0dbf68e45b96cd1ffda4705f33307dcc86c676c1b5104838a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0c435e983bf7756d5fc6aa7a8be8c5eecd904b34459232e616363a6972966a9"
  end

  depends_on "python@3.13"

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/f2/97/ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3/iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test_example.py").write <<~PYTHON
      def test_example():
          assert 1 + 1 == 2
    PYTHON
    system bin/"pytest", "test_example.py"
  end
end