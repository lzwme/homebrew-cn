class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.compylint-devpylint"
  url "https:files.pythonhosted.orgpackages633a13e90e29777e695d90f422cf4fadb81c999e4755a9089838561bd0590cacpylint-3.3.1.tar.gz"
  sha256 "9f3dcc87b1203e612b78d91a896407787e708b3f189b5fa0b307712d49ff0c6e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fe689159cbecdd0be9c24ed756e60da04a74a87ef3a6834e677cef5dd727004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe689159cbecdd0be9c24ed756e60da04a74a87ef3a6834e677cef5dd727004"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fe689159cbecdd0be9c24ed756e60da04a74a87ef3a6834e677cef5dd727004"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f48f04dc67be486fe6d294d5ba2fab898d7079c7b915a4421c463d45322f66"
    sha256 cellar: :any_skip_relocation, ventura:       "e9f48f04dc67be486fe6d294d5ba2fab898d7079c7b915a4421c463d45322f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a4aec538c7861f82134216fa3e033c5a4548e68e4608735a4711405d58fc85"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackages16270dae53cc2c6b55ebdd6d23bae865b419f0f0f9592897b4e3a7069d0ddc3eastroid-3.3.4.tar.gz"
    sha256 "e73d0b62dd680a7c07cb2cd0ce3c22570b044dd01bd994bc3a2dd16c6cbba162"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages174dac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
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
    (testpath"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin"pylint", "--exit-zero", "pylint_test.py"
  end
end