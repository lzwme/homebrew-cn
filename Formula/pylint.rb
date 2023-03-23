class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/a1/f5/4c1b656d479f85dc9b7c4145f95090a0e78b0398e9d217ffe808e8a46999/pylint-2.17.1.tar.gz"
  sha256 "d4d009b0116e16845533bc2163493d6681846ac725eab8ca8014afb520178ddd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85aea59f953e67951bb2cf2b3caed7f4be0b197850d634084e37ac190e8ef2e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65c9728306a5dea3b8688df9ca44d976d02ff693b755213490059c62b736338b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76554694ba780fdb415523b63e36ea20c666b621f68b3024d5a0126fe0c2c844"
    sha256 cellar: :any_skip_relocation, ventura:        "b99c4cac7d007f1cc7a8315cda804e217a6e175934f9eaf5374ad47ca4e6072a"
    sha256 cellar: :any_skip_relocation, monterey:       "314d6579f7ba5a0ad42c955c70eb0b306d4e59c42fdaf227c57c39156d6f212f"
    sha256 cellar: :any_skip_relocation, big_sur:        "156bc7ad27a956b6efe3ce90f280a719edce206ca01a8de688736ef0a84275d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61203bbda0750bc5728c8b449c81c0116e88ff0a490135029751f454a4af7011"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/60/73/6a30d506ac5317b8b8db2a4340172a85a9b545e7fb732f390c1d2a35d8de/astroid-2.15.0.tar.gz"
    sha256 "525f126d5dc1b8b0b6ee398b33159105615d92dc4a17f2cd064125d57f6186fa"
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
    url "https://files.pythonhosted.org/packages/79/c4/f98a05535344f79699bbd494e56ac9efc986b7a253fe9f4dba7414a7f505/platformdirs-3.1.1.tar.gz"
    sha256 "024996549ee88ec1a9aa99ff7f8fc819bb59e2c3477b410d90a16d32d6e707aa"
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