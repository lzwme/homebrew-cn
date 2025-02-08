class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https:github.comsshuttlesshuttle"
  url "https:files.pythonhosted.orgpackages7ca21c5ba56ab6ee872f04abb3b1dfe72c7dd6486d2b5a1c1c2f0e1f4a21ba2bsshuttle-1.2.0.tar.gz"
  sha256 "d887f9873f4e4358f9d51bd85496dd766ae0461f04130d6bed4276f77a1810fa"
  license "LGPL-2.1-or-later"
  head "https:github.comsshuttlesshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62faa7e26ce24e362d5966a8857f238e80352e0537231818cfecbdc58b2beda3"
  end

  depends_on "python@3.13"

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin"sshuttle", "-h"
  end
end