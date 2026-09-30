class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/0b/80/a656e8958cd35102aeaa2e5c4edf6d781d806df58650fa4368c8102df47d/sshuttle-2.0.0.tar.gz"
  sha256 "7347ff01093d471c4e9a299b9c7abd4a18eac4fddfd4cf868bedc623cab71091"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c0b0765d8502aba4d3dcd340aa458bf03cd111e8f9ea8730c16ffb0e780ae77"
  end

  depends_on "python@3.14"

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshuttle", "-h"
  end
end