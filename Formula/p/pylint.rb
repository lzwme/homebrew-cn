class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.comPyCQApylint"
  url "https:files.pythonhosted.orgpackages23ef99c1531ad5454a560a9ff17789320e68d8d7aaceaa8222b293e3fa7488e8pylint-3.1.1.tar.gz"
  sha256 "c7c2652bf8099c7fb7a63bc6af5c5f8f7b9d7b392fa1d320cb020e222aff28c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72e516f8f9ad556ef7d3d6984ecadb90beb35667163b94807ed0b3a7496eb78e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f419e4b9abb5d94be98d13770234e8b61f32032cd13b78ef25d4d89c53e53ae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada341e3d036ed98d6558c16e9030fef3409e7967d8beae8836c67929cef2e57"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eef1b6936882ef656f0c430e13c0a4043e141e24b6b6259f2beccfbbbf9d204"
    sha256 cellar: :any_skip_relocation, ventura:        "2584a39bee2d4dee2ec05932a2d46416130240aad346f8d1de1dac4017301186"
    sha256 cellar: :any_skip_relocation, monterey:       "97382be31c7d1560cd1253cbf21f4174a6a13f3b20000b00215f423c06ceee9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15cb0989a8b4bd186cebbda6f058b0dacd13694200e12ee0a9529cfb6506d3a1"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackagesa9b9f11533eed9b65606fb02f1b0994d8ed0903358bc55a6b9759e42f1134725astroid-3.1.0.tar.gz"
    sha256 "ac248253bfa4bd924a0de213707e7ebeeb3138abeb48d798784ead1e56d419d4"
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