class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackages5df5755fc9910447e9aa41752372280e880f19ef1085eab0add61913bd30eaeaxonsh-0.17.0.tar.gz"
  sha256 "299be7f25f8dfb21d9a62756154f408674809025ed7871b03f70d9507987509e"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d695b8f834f5189b2bb016c68bfc0bcb212cd5c3d647d4c84e48a4354df4b14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "617177a4c5c56377fbec63088810af636e8779fdc078af5da43eb769aed99dec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e148d0f672e11ec4fc2e5c5167098cafb61e8a8500780c68d37ea1f0474306d"
    sha256 cellar: :any_skip_relocation, sonoma:         "96048294481fee5fb8cdde2bec5f21647e1217986f3f9161c06af8a8f0592773"
    sha256 cellar: :any_skip_relocation, ventura:        "8268e85d6c1dae21bae6d29836d6ae6d3575ba2bef532bef74bd63645c5d75bf"
    sha256 cellar: :any_skip_relocation, monterey:       "abdd8649a2bab224ab00e232de6cf3dc936d81fa9e7fe50c9146caf153623d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed28db2b877dee67901f2201f8ae9cc26fe9c188936b47a83c8eae2dd3d8678"
  end

  depends_on "python@3.12"

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages476d0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879fprompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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