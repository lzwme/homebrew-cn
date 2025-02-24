class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https:github.comsshuttlesshuttle"
  url "https:files.pythonhosted.orgpackages48222b3b0f90efb215ceb7b4f8e7c89a265bd511f0b3c7321345cea5c5425fffsshuttle-1.3.0.tar.gz"
  sha256 "57af147d4c8d2fe978cbb2b8611aaee6a3521004e52650a85c7a82cd09c96224"
  license "LGPL-2.1-or-later"
  head "https:github.comsshuttlesshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "062ef20359ae5524d87ace52b410437c0099ed8dc9b96a756be3efab4d6fab6e"
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