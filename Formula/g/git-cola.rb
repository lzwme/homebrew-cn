class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/d7/e6/9272e207377034aea65b463a60c76ea764b987bf48bbb55744ea9124f85b/git-cola-4.4.1.tar.gz"
  sha256 "ae8464d202cd917b204b1b0f113609a8163ea5678396b88ab9320a944afe6cc7"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ff1b4e71893296bbdd903e58fd0984dd4b0bbb29e4858e0c48a24a1af1ee040"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88aa915c7a338a72b1cf3d6177ce07654ab227fef8568a96377f7e512cac58ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85d898951add162d8edec0019ea2f836472f3283575c95eb3f31bb741684b5f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "869c24a0b6745dd2d02d11681761cc62a487a2b1731e7c6be4f71eab25b36124"
    sha256 cellar: :any_skip_relocation, ventura:        "97bdffcdee955a020a576ad9067db99938326e448a3de211f28aec3828c5d74a"
    sha256 cellar: :any_skip_relocation, monterey:       "93be3df4a912c741dbe56f98d9577cc50906f72e379f0d1a2f2afcc569fc5591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c2f77d40cda92b3effe5a508572a98d2df4f4a5e4357dd1aa54fb648de6cfc"
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