class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.comPyCQApylint"
  url "https:files.pythonhosted.orgpackagesb4ad0a538337cac5089af67b712f18345a12ac2ae14d4a4f04994bc7c1995a71pylint-3.2.4.tar.gz"
  sha256 "5753d27e49a658b12a48c2883452751a2ecfc7f38594e0980beb03a6e77e6f86"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f715a2ed613c688a7628b71c8ea2f8fbb56bcb3b0e32993b31142ad32574dc7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f715a2ed613c688a7628b71c8ea2f8fbb56bcb3b0e32993b31142ad32574dc7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f715a2ed613c688a7628b71c8ea2f8fbb56bcb3b0e32993b31142ad32574dc7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c04795e267ffad09c8969af7b16e9f297660d2406c03012f21b6dc22951112e1"
    sha256 cellar: :any_skip_relocation, ventura:        "c04795e267ffad09c8969af7b16e9f297660d2406c03012f21b6dc22951112e1"
    sha256 cellar: :any_skip_relocation, monterey:       "c04795e267ffad09c8969af7b16e9f297660d2406c03012f21b6dc22951112e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a1c1db9fd95212ca64aa3b839e4908a65787980ce8d535d1656074f938765d0"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackages278f79adb88627d194824decf7b9f4dde9e059b251a7b76809c99f4803be258eastroid-3.2.2.tar.gz"
    sha256 "8ead48e31b92b2e217b6c9733a21afafe479d52d6e164dd25fb1a770c7c3cf94"
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
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
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