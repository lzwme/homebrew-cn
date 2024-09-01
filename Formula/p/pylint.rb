class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.compylint-devpylint"
  url "https:files.pythonhosted.orgpackagescfe8d59ce8e54884c9475ed6510685ef4311a10001674c28703b23da30f3b24dpylint-3.2.7.tar.gz"
  sha256 "1b7a721b575eaeaa7d39db076b6e7743c993ea44f57979127c517c6c572c803e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ee92a10c49e151505397f9a17d6745784e35092ed412c4bf855c8abafaac833"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ee92a10c49e151505397f9a17d6745784e35092ed412c4bf855c8abafaac833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ee92a10c49e151505397f9a17d6745784e35092ed412c4bf855c8abafaac833"
    sha256 cellar: :any_skip_relocation, sonoma:         "48aa87c2e9f134160e9b5cc3453370662d70170ea16262842b23e25881cc752b"
    sha256 cellar: :any_skip_relocation, ventura:        "48aa87c2e9f134160e9b5cc3453370662d70170ea16262842b23e25881cc752b"
    sha256 cellar: :any_skip_relocation, monterey:       "48aa87c2e9f134160e9b5cc3453370662d70170ea16262842b23e25881cc752b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c476dc33ef136cde2cc1bc18515dec6a6f718ea1335b9ec90673af6b3f4c6f"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackages9e531067e1113ecaf58312357f2cd93063674924119d80d173adc3f6f2387aa2astroid-3.2.4.tar.gz"
    sha256 "0e14202810b30da1b735827f78f5157be2bbd4a7a59b7707ca0bfc2fb4c0063a"
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