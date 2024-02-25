class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https:github.comPyCQApylint"
  url "https:files.pythonhosted.orgpackages7aa90edfeed967a09781f7f15ab347a57467cc12341afdde3785474f0c6129bcpylint-3.0.4.tar.gz"
  sha256 "d73b70b3fff8f3fbdcb49a209b9c7d71d8090c138d61d576d1895e152cb392b3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "652f27470a077962313aa96f6633dc0b83e4e2f1a80ed01ed5ce36522ef46ffa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e598cd90962d8978ebeb079ceb3c073b2ac076e013133962f89799a852527aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f8a9930b6a8c14858b9e5a886ea1d89cef93fc061ce0806f5c5b29457bb1fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "98dae61be4d4c39f80bc4a6a390fc17fce0906665c53d5e87542a4233c80fd8d"
    sha256 cellar: :any_skip_relocation, ventura:        "4d004cc806918914c73d31b46c098121fe7cabef6e97043f2cad450c66e59de7"
    sha256 cellar: :any_skip_relocation, monterey:       "0bda98f9b50d0eff4a987a37329e3951af1e67003c6985cddbbfb8c2d62b5661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "737ea587adee8f82701013c3b1dad9348568fe2d6daa267da39fd064cf877bca"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https:files.pythonhosted.orgpackages96aa60bf19fe9d33cd8753b0547df513c3004b33b9a482800d3af0845bcbb3d0astroid-3.0.3.tar.gz"
    sha256 "4148645659b08b70d72460ed1921158027a9e53ae8b7234149b1400eddacbb93"
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
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesdffc1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
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