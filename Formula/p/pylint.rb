class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.compylint-devpylint"
  url "https:files.pythonhosted.orgpackages81d84471b2cb4ad18b4af717918c468209bd2bd5a02c52f60be5ee8a71b5af2cpylint-3.3.2.tar.gz"
  sha256 "9ec054ec992cd05ad30a6df1676229739a73f8feeabf3912c995d17601052b01"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9fb054fe5e6361ba0ec1d09c3e0f4588d630b899d7f383a42d421b71c9b789b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9fb054fe5e6361ba0ec1d09c3e0f4588d630b899d7f383a42d421b71c9b789b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9fb054fe5e6361ba0ec1d09c3e0f4588d630b899d7f383a42d421b71c9b789b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b124bcceef9bd0eea4630ec17979a08848bd1cb5ec97f6d35f48f855015c0f31"
    sha256 cellar: :any_skip_relocation, ventura:       "b124bcceef9bd0eea4630ec17979a08848bd1cb5ec97f6d35f48f855015c0f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83464140a66923b624151b3876a12682542c68378728f6226012be9879074b9c"
  end

  depends_on "python@3.13"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackages381e326fb1d3d83a3bb77c9f9be29d31f2901e35acb94b0605c3f2e5085047f9astroid-3.3.5.tar.gz"
    sha256 "5cfc40ae9f68311075d27ef68a4841bdc5cc7f6cf86671b49f00607d30188e2d"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages704386fe3f9e130c4137b0f1b50784dd70a5087b911fe07fa81e53e0c4c47feadill-0.3.9.tar.gz"
    sha256 "81aa267dddf68cbfe8029c42ca9ec6a4ab3b22371d1c450abc54422577b4512c"
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
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin"pylint", "--exit-zero", "pylint_test.py"
  end
end