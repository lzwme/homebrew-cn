class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/c2/94/85870fc02dfe4ab0885c440e7e41f6a986b10e43eca6717e90f8ce1215cc/flake8-7.4.1.tar.gz"
  sha256 "84ea5afcaf344487b0ea5baaebb8100f4cfaebc01f755998f75876664029f587"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d66e8f966c5d03fd1a6330bcabb59086cdb95f97aa798073c5cd31b353e4ca2f"
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