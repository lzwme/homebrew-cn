class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/f5/df/f975b45b77d06500e5bf8fb0b7e7dae9ca2cfcd895ca85288efcb2d8f75d/git-cola-4.4.0.tar.gz"
  sha256 "a46256d5ab9689c3b3ba7a2a220a8a8efb890bd1dd842feb03a75794519cba72"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d01686e407e23c0c4e08721cd908146004e46b4fbb6c61073ba994134e169d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a953570a96371128eb75e7950ee2ed4a1cebcdb820ef9da68e7866cdf0438f6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec562daf700424c7d07932ea110ceb15c21218be3acafbcf8cf729eb930c3ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "bca7bf5a146b1779aab329b1c6bc085b2e0e9cef03b40f839e4c45d10def49fb"
    sha256 cellar: :any_skip_relocation, ventura:        "456e610578b361ee22409b3ef2ede6609c9db7531633722830c63f8b5a2eabdd"
    sha256 cellar: :any_skip_relocation, monterey:       "3c653e57bfbc801724d869e8336aa8a509e693f43618a887e1497a9126868671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4e6cf1c81a71828dc64111d825eebd81331ddd8a42522fddbc116362a61cd61"
  end

  depends_on "pyqt@5"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"

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