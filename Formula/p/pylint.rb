class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/b6/2f/e80cc4301c81c41a8836d726377daeebf5901a33c06ba8c2d5afb94f7612/pylint-4.0.0.tar.gz"
  sha256 "62da212808c0681e49ffb125f0a994c685d912cf19ae373075649ebb5870ec28"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d80a29b729ef057c93606fb8e161bd5b28d2ec88d3a8d7921aa2c122d0e4b74"
  end

  depends_on "python@3.14"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/a7/d1/6eee8726a863f28ff50d26c5eacb1a590f96ccbb273ce0a8c047ffb10f5a/astroid-4.0.1.tar.gz"
    sha256 "0d778ec0def05b935e198412e62f9bcca8b3b5c39fdbe50b0ba074005e477aab"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/12/80/630b4b88364e9a8c8c5797f4602d0f76ef820909ee32f0bacb9f90654042/dill-0.4.0.tar.gz"
    sha256 "0633f1d2df477324f53a895b02c901fb961bdbf65a17122586ea7019292cbcf0"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/63/53/4f3c058e3bace40282876f9b553343376ee687f3c35a525dc79dbd450f88/isort-7.0.0.tar.gz"
    sha256 "5513527951aadb3ac4292a41a16cbc50dd1642432f5e8c20057d414bdafb4187"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end