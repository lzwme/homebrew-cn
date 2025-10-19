class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/56/eb/c14bbd7b09f53473bfc4ae5f0a979810c272bd1ec3a0f06e2322da87163a/mackup-0.9.0.tar.gz"
  sha256 "d1aa845364dcf51ae3d5d9267ad62ac1941d2964ebe6a6e80f0b1b1cbdccc638"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4a26ddc2474f47fde5627d0498d7e98aa86d5fb11e5b4077689088de3ffe089"
  end

  depends_on "python@3.14"

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mackup", "--help"
  end
end