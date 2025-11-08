class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/f6/02/afbfad312b851abac73ede944792c3b507199d504f9e6c4d1b3df1854b6f/mackup-0.9.6.tar.gz"
  sha256 "6304b9ae6f5168e2700de9b3f8b177a1850df51f33977e7f3f332378f7c97b35"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5d1a5b69787bd9bdfbd1ca17952d3cee937d2a8fa77690e50f6c5edcdb2db64"
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