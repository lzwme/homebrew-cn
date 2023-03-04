class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/56/5c/6bdcf113646b1dc0459d48e693932e1156376341b74a43ff0a4f79623710/pylint-2.16.3.tar.gz"
  sha256 "0decdf8dfe30298cd9f8d82e9a1542da464db47da60e03641631086671a03621"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c37725f094f3125200afeb00d809593a37b154f944fea12f5725711c195ad884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275e3f288fe5a5c718d835957fb3d30bfd48167b2c60f0e8f4cb8b97cefbf4d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "252619584ff3c8e2e19110a68f40d552525e9990e7093816267329d4156961e3"
    sha256 cellar: :any_skip_relocation, ventura:        "0d6279927eee89e82dd69da599fa6464afc1729a9693628f3f13283a23125704"
    sha256 cellar: :any_skip_relocation, monterey:       "13b0413121238c2c1e40805003bb52aa28323491a362a4ba00b7a3809409be5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b90f4b50620e4efa157b06fbde2eddfa16c86ea304d6dc63dce7a3483601f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec199cb9999682c7429fdd02b3262fdbfedb332a71f9163791f2199ad2ae134"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/15/e5/7dea50225cd8b44f1488ae83a243467fe6d2a3c4f611d865085b4bba67e5/astroid-2.14.2.tar.gz"
    sha256 "a3cf9f02c53dd259144a7e8f3ccd75d67c9a8c716ef183e0c1f291bc5d7bb3cf"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/8f/5f/01180534cebac14f3a792bf2f74fc99d34531c950c308fdebd9721e85550/platformdirs-3.1.0.tar.gz"
    sha256 "accc3665857288317f32c7bebb5a8e482ba717b474f3fc1d18ca7f9214be0cef"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
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