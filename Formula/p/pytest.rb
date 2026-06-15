class Pytest < Formula
  include Language::Python::Virtualenv

  desc "Simple powerful testing with Python"
  homepage "https://docs.pytest.org/en/latest/"
  url "https://files.pythonhosted.org/packages/84/0e/b5858858d74958632c49b72cb25a3976ff9f632397626715be71c89d3971/pytest-9.1.0.tar.gz"
  sha256 "41dd9148c08072446394cefd3d79701701335a9f4cae69ba92e39f6c7f5c061c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e3240ec9e55e9c3eec33cbf6105564aad3702ff70388cac4c2b301b5f8f3288"
  end

  depends_on "python@3.14"

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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