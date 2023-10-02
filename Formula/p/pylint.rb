class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/a3/e9/21f9ce3e4b81eef011be070a29f8a5c193e2488ed8713a898baa4e8b3362/pylint-2.17.7.tar.gz"
  sha256 "f4fcac7ae74cfe36bc8451e931d8438e4a476c20314b1101c458ad0f05191fad"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daf26ac829de44699f6cdd3ea412bcda015a7d140e0cc0da8a201693874345d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "778d873309440983099182c2924c759935a85ead2372ebfbef8a35dcf3c7b360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db3a4dc1d7fdac4302d73c1efa78582ce930aba4bc548092e8520d0347687be"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d7b770be20b9b472c08d9461b2c3bb9c0dbb716331d33336c293d53a4868a9c"
    sha256 cellar: :any_skip_relocation, ventura:        "484296f18083e8017413fd1064bc3c655b0ccee6e29ce9cc20e34ac7482f7f54"
    sha256 cellar: :any_skip_relocation, monterey:       "82b4e92ccdf85e6c6b78c278a8e7541a6a54891b7e55cd04ad9b0f93f7b3b4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8df9a745c01c355aff1200912a0f71733a22b44402f4a6777a90cba369b516"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/58/3d/c18b0854d0d2eb3aca20c149cff5c90e6b84a5366066768d98636f5045ed/astroid-2.15.8.tar.gz"
    sha256 "6c107453dffee9055899705de3c9ead36e74119cee151e5a9aaf7f0b0e020a6a"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
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
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
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