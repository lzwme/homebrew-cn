class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.compylint-devpylint"
  url "https:files.pythonhosted.orgpackagesd5e73616e8caa61f918c4864db075800a6bd7422621618045c188fd45c3f7a2bpylint-3.3.5.tar.gz"
  sha256 "38d0f784644ed493d91f76b5333a0e370a1c1bc97c22068a77523b4bf1e82c31"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31df50fd578fd30941d707c499d7772a797c0eba3ffd0f9c3ed6e71238e1ead2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31df50fd578fd30941d707c499d7772a797c0eba3ffd0f9c3ed6e71238e1ead2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31df50fd578fd30941d707c499d7772a797c0eba3ffd0f9c3ed6e71238e1ead2"
    sha256 cellar: :any_skip_relocation, sonoma:        "900e103636d3202dd1f8020868156ff9435f34035770c3353c0ed5a73f71b1fe"
    sha256 cellar: :any_skip_relocation, ventura:       "900e103636d3202dd1f8020868156ff9435f34035770c3353c0ed5a73f71b1fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71232164d324ef1d97f08471ab538f64df0884a2641d53f1aec7a6bde6b7c4e7"
  end

  depends_on "python@3.13"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackages80c55c83c48bbf547f3dd8b587529db7cf5a265a3368b33e85e76af8ff6061d3astroid-3.3.8.tar.gz"
    sha256 "a88c7994f914a4ea8572fac479459f4955eeccc877be3f2d959a33273b0cf40b"
  end

  resource "dill" do
    url "https:files.pythonhosted.orgpackages704386fe3f9e130c4137b0f1b50784dd70a5087b911fe07fa81e53e0c4c47feadill-0.3.9.tar.gz"
    sha256 "81aa267dddf68cbfe8029c42ca9ec6a4ab3b22371d1c450abc54422577b4512c"
  end

  resource "isort" do
    url "https:files.pythonhosted.orgpackagesb8211e2a441f74a653a144224d7d21afe8f4169e6c7c20bb13aec3a2dc3815e0isort-6.0.1.tar.gz"
    sha256 "1cb5df28dfbc742e490c5e41bad6da41b805b0a8be7bc93cd0fb2a8a890ac450"
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