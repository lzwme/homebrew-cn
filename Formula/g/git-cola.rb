class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/f5/df/f975b45b77d06500e5bf8fb0b7e7dae9ca2cfcd895ca85288efcb2d8f75d/git-cola-4.4.0.tar.gz"
  sha256 "a46256d5ab9689c3b3ba7a2a220a8a8efb890bd1dd842feb03a75794519cba72"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c13a3a27c8bf59c1ad006aef9aacf049ebc243fe6a6d3e22b60712e19ba1b931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c533af93332981c1c1f0d8c24f41a84c25871e92eac5029394b8e7fe2dc28343"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43cb88f7ec9e0cae41ea4097c8274c960743181f253beb873509048be5349e01"
    sha256 cellar: :any_skip_relocation, sonoma:         "233bf66b237800758f713fdb5c13b97bd1dd6f74cc64702b1ebb33b8becb4cc7"
    sha256 cellar: :any_skip_relocation, ventura:        "dc229b347257b31b75496d7a314bbbb80db85bd605bc95a73a1010171cd40ade"
    sha256 cellar: :any_skip_relocation, monterey:       "adc716bb030c73c093eac0dfe9fb08d009aa12e1cc786cd7fe743860ac56e227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f92f14ce1fd5f51241b5c3c3830cd53a8250ddb6d77e5df961ba87a9e991d61"
  end

  depends_on "pyqt@5"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.11"

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/eb/9a/7ce646daefb2f85bf5b9c8ac461508b58fa5dcad6d40db476187fafd0148/QtPy-2.4.1.tar.gz"
    sha256 "a5a15ffd519550a1361bdc56ffc07fda56a6af7292f17c7b395d4083af632987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end