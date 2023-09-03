class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 2
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b24b698c0206d6946eea613d6af6ed944dba5fc5a7ea594da6831a37f01d0f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0f8c9517347c116e9d0ae630001774e4fff32863a2a15a685f54f99a92721f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c413121ae2b67446dde2c87cb018144b6347a8c273ec4bf8f5e5899dfd64f64"
    sha256 cellar: :any_skip_relocation, ventura:        "66c88d177f2d358668350548d51d4aab00094ccb80b29849a1bd06bd271244be"
    sha256 cellar: :any_skip_relocation, monterey:       "73bd40b81328c9e99079260713daaf91b19edb19a9b6495b1d6cc3eacf4c84a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e243b30d5cce892179aace89b079c184cdd6a1352c82d3c2c934543ff9ef5129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b2ac01c4ba079a726fa5db4532db0cc8ef3f11a88f998fcc4052374a271980"
  end

  depends_on "cookiecutter"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8d/1e/33389155dfe8cebbaa0c5b5ed0d3bd82c5e70064be00b2b3ee938da8b5d2/GitPython-3.1.33.tar.gz"
    sha256 "13aaa3dff88a23afec2d00eb3da3f2e040e2282e41de484c5791669b31146084"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end