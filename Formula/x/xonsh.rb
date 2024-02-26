class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackagesb02759c5fdf04ea19a2c9d1ac1ce6616028ba424edc832b5d926308c7aaa82e3xonsh-0.15.0.tar.gz"
  sha256 "3ba9bfd70540fa61cc2836f4746152a9e7bd92b918081c70f391b99a89e8a1c6"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5f980034f0ce61d5086c38bc7174db0287d5a0f2aa45472769c0e9413eb895a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3b62a2b731f324c51ee30860241711cabd29e045bbd010db6d3f2f496ad829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2f29d93bbc355526d0f5db58b3964449cb6bda602949b281df5bf304a268529"
    sha256 cellar: :any_skip_relocation, sonoma:         "944e8998c3e2be3880e020affa94f6932e92a967c86f1bde9cb604fd6823bba4"
    sha256 cellar: :any_skip_relocation, ventura:        "567b0c9878148ff29fbbfad86e82eb58bcc3a5e436a471f8dfb82bc64231edef"
    sha256 cellar: :any_skip_relocation, monterey:       "214cedf41b2c0ac899dd5ca558e2b32b61d71181891bdd12f3cf90d950d62038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59f13292ab6a56e9caeb8abc10ef809d0fae32f4c1beb7e3dfc64ddd1c7ff2a"
  end

  depends_on "python@3.12"

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages99ce172e474a87241a69baad1ce46bc8f31eae590a770cb138b9b73812c8234dprompt_toolkit-3.0.40.tar.gz"
    sha256 "a371c06bb1d66cd499fecd708e50c0b6ae00acba9822ba33c586e2f16d1b739e"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackagesa72c4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https:files.pythonhosted.orgpackagesffe1b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}xonsh -c 2+2")
  end
end