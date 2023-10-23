class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/10/ab/f0ad2a4fb3265d71685627db452398f769b48d64d81c7d66ca8c4f4c198b/pylint-3.0.2.tar.gz"
  sha256 "0d4c286ef6d2f66c8bfb527a7f8a629009e42c99707dec821a03e1b51a4c1496"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8298909924a7f93e1ab370cc199da1c5de733b552f65a0f74b8628b8467096e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7cce970335c6cd4871def0c4b036fa3940a6ddc8da6e17562eabe71d9d8b9cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820a4ad747feb87d05d74e0c73fdc9f5f76d1a6f606fa0d504cf0ea3d6200322"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdb6660be179f247eb9a08af1d7f024481df6c3492979c0705ecdeb5e627c21b"
    sha256 cellar: :any_skip_relocation, ventura:        "9896837d9d495e440a6915f2c841552f8be19023f6b8a3443e2bc6294150425f"
    sha256 cellar: :any_skip_relocation, monterey:       "ed8658eaef29cc71ccda527769eb4fa5228b0333e0fd415f77392e27202c3436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "549ec286e3d925fb1dce27aa7810e82e37a4bbc46458229993e3e7b101117dfb"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/69/53/07229db171855e410bf40a996f1d49cc35222e18a1c95cd566e69bb9e0e5/astroid-3.0.1.tar.gz"
    sha256 "86b0bb7d7da0be1a7c4aedb7974e391b32d4ed89e33de6ed6902b4b15c97577e"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end