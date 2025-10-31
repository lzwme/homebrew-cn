class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/0b/14/0df18836efccc6d5f72242b2659c63a672a90ac6a89ffd870c92001ca623/mackup-0.9.5.tar.gz"
  sha256 "e69c34c81697865c4bf982da4abee349f08cb3b60fae0b8fc4f2e0e128ab46a1"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "769acc0faaa371de760356a5381a002394b3e3ac7e139d475714dbfe65611640"
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