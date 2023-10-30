class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/d5/df/41ebfbae6c317da0569637bf16c74ace7e6dd729c075677fff09b8ca5db8/git-cola-4.3.2.tar.gz"
  sha256 "5ae4e7299e4f455f162dc8ce79cdf351a80da656ac7acb58459c19691b04e83f"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c0556f0121b30e663fc8aec942fbe60c60986bd323e4f9129dc34b4373b569c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d889576442db7b7b75029c6c366b6244c2e248903c62d8f7580e9e2e4e20d31e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b03ec98981423445d2f809e7a3060e5a308097c3c4be31d2c6b325c4d3057a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0c68840b86da85550c16e033433695b6755310e554292c3b69b3a01e2af3631"
    sha256 cellar: :any_skip_relocation, ventura:        "bd11bfb10479b74eecd00359cbcf93cb35d45fa68a7f5c4715a82fde8f15f547"
    sha256 cellar: :any_skip_relocation, monterey:       "fa440d9ce00bc70a07a1bd7188935c94d270c359da331ee10e4dad85e8f59a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea6d8b43f14d8f8582f8e10512848b347f1d9f44ef3e1d50e8ddbc2590b05c0"
  end

  depends_on "pyqt@5"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.11"

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/ad/6b/0e753af1197f82d2359c9aa91cef8abaaef4c547396ffdc71ea6a889e52c/QtPy-2.3.1.tar.gz"
    sha256 "a8c74982d6d172ce124d80cafd39653df78989683f760f2281ba91a6e7b9de8b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end