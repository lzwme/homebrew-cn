class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.comPyCQApylint"
  url "https:files.pythonhosted.orgpackages6275e48496ea7fc2de24b361dd8084300a2f7e51c47e82363c736026d41cdf2fpylint-3.2.0.tar.gz"
  sha256 "ad8baf17c8ea5502f23ae38d7c1b7ec78bd865ce34af9a0b986282e2611a8ff2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af8eb7086fe7a31209eecbf94e3b4c7a578ed5cc687fecca065c65c7313607f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ed3a185f06c24f2df83d258a780fe525e3b2ae4d1d5cc57b870f24d9c81f157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad98c78a291131a0d0a40e7406e4e7d3cb76256bd63d2afa86cc789e827e76d"
    sha256 cellar: :any_skip_relocation, sonoma:         "282a5c22b8246836dc844e71f42519ec6e963984f0613728adf52565ccb19373"
    sha256 cellar: :any_skip_relocation, ventura:        "eb2b7689d261bae9947a1f42be3abe95df93fbb346af6b5a2882ced280cac9ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4a04510ea53f31171a8d28e1f680002ae0652d63226e7cd251f7c45522dd09ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ad56d25b42d542df1044c9a0e258b0256db7daf7128cebacc8c7b400a307f0"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackagesb6e8f86aa1fd91b7fa5b51ed53c9a06a94dba7cc388b51cb712e8721c41605efastroid-3.2.0.tar.gz"
    sha256 "f7f829f8506ade59f1b3c6c93d8fac5b1ebc721685fa9af23e9794daf1d450a3"
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
    url "https:files.pythonhosted.orgpackagesb2e42856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages2bab18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
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