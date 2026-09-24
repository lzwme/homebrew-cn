class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/d9/71/d9a14f80e00bd0fc2871d85ff7b7a64d84c32f58665ac060de6705a6a78f/flake8-7.4.0.tar.gz"
  sha256 "d3e0beb3d152209b4dc50fa5e3132844bf4ee4ff994cec87d6913d06b8eb5afc"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30ea98dab5ff24d552dfecceaf698dc688c8739a14c358fa580b89c247b24f56"
  end

  depends_on "python@3.14"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/86/df/178e41c9ed0ff33c23b3f3757e4e658c889f9abc5ad76ece6cd607b12e9c/pycodestyle-2.15.0.tar.gz"
    sha256 "318f5db083869b4c4dad922d0b11124fb27ab181b6730b93371da671e31bd50e"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/6e/07/587d938ce8ffea54aa23337c4a827a72c27a3a994b4346899682704af588/pyflakes-4.0.0.tar.gz"
    sha256 "492b27735181e3d4a6acfc08738948b666bf3e696781854ea6e0d8540d566d52"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~PYTHON
      print ("Hello World!")
    PYTHON

    (testpath/"test-good.py").write <<~PYTHON
      print("Hello World!")
    PYTHON

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end