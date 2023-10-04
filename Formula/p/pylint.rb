class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/aa/f7/325b71d78faf9fcf1c246669a2448356fe3d7d69c5f93d48f41cc241a6bb/pylint-3.0.0.tar.gz"
  sha256 "d22816c963816d7810b87afe0bdf5c80009e1078ecbb9c8f2e2a24d4430039b1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e2a0328ca5538c915ab20578e82af95993ba78da45908fd007de238106b481f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62096db6fc18cf3c1f1919c0dac13d34f27a80cd2b0e2f716ff4335f94c94078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae345d16c5c5d9256317fd3ad7cb63bf0373f41e91bb2fd74a357ad9ef3e70a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "41110899e28782871c5a1926952428ba0c4ca0aab26e5dbb8a121ec8360a7c8a"
    sha256 cellar: :any_skip_relocation, ventura:        "30719a94f9eed923351ff83c52160c877412dda3eef69eff9b3fafc1ad67b90c"
    sha256 cellar: :any_skip_relocation, monterey:       "43bec9bee2be78f8a280f17ccf34bd5ee96ed6d0662d0c46040311cdb6be1c16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d28f1246089435ccb9e708d207f5b55668f002dc39b4458cd02f689fd0b7fa"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/60/f7/536d171ce4e334b0ceec9720c016f59f2c75d986e4dbc52b34601cd7834a/astroid-3.0.0.tar.gz"
    sha256 "1defdbca052635dd29657ea674edfc45e4b5be9cd53630c5b084fcfed94344a8"
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
    site_packages = Language::Python.site_packages("python3.11")
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