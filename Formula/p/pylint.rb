class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.comPyCQApylint"
  url "https:files.pythonhosted.orgpackages0c4cb561478a1ccb91e9b02965cb999d2281894d43e68c0bf3777d023af15f11pylint-3.2.2.tar.gz"
  sha256 "d068ca1dfd735fb92a07d33cb8f288adc0f6bc1287a139ca2425366f7cbe38f8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "583e28b0eafa5bfec8f07dcfa565bc332a77ad5aed710e9ac572d414a21b6164"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "427fcacc3ce90cdcc1b795b6fc7dd0ee9247092c677bdcd5946e4499270ab0c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71d3f4db21e3eb6f2c0036cbdafb3797d8e9237fbd24fb0a50537524aab690ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c77700d108ab21dae22f69df802cf29f2cadef95b4101ec5310dec8c191d2b2"
    sha256 cellar: :any_skip_relocation, ventura:        "077e06af14e756b0bf8d0f04ea298b8f25dc4f338debabab831e3c4fefacd2c1"
    sha256 cellar: :any_skip_relocation, monterey:       "da371c963fbf2e8228c8d61b5fd94e80fb33a47f64e1b4ef41e3e84575648c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8294a99caa3fb8e8035e06c397ca10335514f182528b409fe8b3f7a34566ba0"
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