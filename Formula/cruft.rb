class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69279363b749bcff11ac463e414e0894249f1418bb159557b1291def153c6cdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ab0f7d5e917c01d6a7b296a77c839a09122fc6068ebb0ba0eb198161dac2f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0807446c9aae650efbfb202437ef0cac6dca8b1da4208b998a3b2951e6fda8d4"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4e0cb4357bac11ca5e7aabaca29e2d21c457fcab81ec0cbd49eed33fba7a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0857213cc62212b38582f7c2934140a21b3c82195d38fbe9c39e1d4990c5df"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fdff4d95c76f40dc7af6542136f0634872a693aaf139043d1b848e7b9990b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6195a8e10d1d79275285e82b15b34eba3776713a8430d02798d316ae62e3dc1f"
  end

  depends_on "cookiecutter"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/5f/11/2b0f60686dbda49028cec8c66bd18a5e82c96d92eef4bc34961e35bb3762/GitPython-3.1.31.tar.gz"
    sha256 "8ce3bcf69adfdf7c7d503e78fd3b1c492af782d58893b650adb2ac8912ddd573"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
    sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
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