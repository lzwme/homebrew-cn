class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/9f/cc/cf24bfbb4591c4cb89cc1d78932874bf75548f837859cd9947587d471c9c/pylint-2.16.4.tar.gz"
  sha256 "8841f26a0dbc3503631b6a20ee368b3f5e0e5461a1d95cf15d103dab748a0db3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2da9f957b23c6be385a9453e351edf3dd9e0fc85b7dce3265a36267901678e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe22b6b9c52c6f4de05b3c3072af49de06477eb4c81683d32a0bbba0362fccd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2089651598e7280c987eba8805ed0db4165ba0bf789939070fd5d179eb40d3b"
    sha256 cellar: :any_skip_relocation, ventura:        "9edc35217c60bc149b7ddc75fb7e1835c37a7b59fe15bfbc7123f5fbfc410e07"
    sha256 cellar: :any_skip_relocation, monterey:       "4ee4df5d91410f6184f5e237485c642f28109f0725808c8740ffbd15be3beadd"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fd5e85cd37639f03afbf89685df96159b5a8a0dda7944e6a16b871d48e84c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a37d25fd6ecd5257bdbbad8b4c07eec862271f70fa7ea4121ad9732128a2e417"
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