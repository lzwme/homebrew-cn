class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.comPyCQApylint"
  url "https:files.pythonhosted.orgpackages14cf2e36e27381a3d8b3736d0deab9838fc4b3b59f609002ddae1f2c85bd6aaepylint-3.2.1.tar.gz"
  sha256 "c4ab2acdffeb1bead50ecf41b15b38ebe61a173e4234d5545bddd732f1f3380a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88351eaba2358497b3d3dcaa8f6ed87d1aa528314965f05112a0487715143a75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20c71e437a2293df3ef4f082429d2db48ddce05291980b76ea53fad0efde7881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "712d37bf7634ffa84779fcecc6aa4e67233eebc905356ed060b2cb1b2b2e526e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad9d8154d41b3cc41eee39c2d9ab047bfc286db10aab51b6dfb269e9cdb832f0"
    sha256 cellar: :any_skip_relocation, ventura:        "ec4b73ea3366a3658b854c65e55152df09086b18c83bc3c20f32fb6741607a55"
    sha256 cellar: :any_skip_relocation, monterey:       "26d91fe9b95f5623804cfe9cd36b068b30da67c4c53df27f7a9fda15ac4846a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebea90ab9c30466523bd954ad5509e272dd3870424a62ce95636d85243a84e8"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackagesc08c3bdbdc8f0c37cf105d6758574f4650c960f57e40d08c5c0ac78a06e515d5astroid-3.2.1.tar.gz"
    sha256 "902564b36796ba1eab3ad2c7a694861fbd926f574d5dbb5fa1d86778a2ba2d91"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages174dac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "isort" do
    url "https:files.pythonhosted.orgpackages87f9c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "mccabe" do
    url "https:files.pythonhosted.orgpackagese7ff0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages2bab18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin"pylint", "--exit-zero", "pylint_test.py"
  end
end