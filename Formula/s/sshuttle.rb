class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/f3/fd/18f958bb11d6ae59c8a1388bf03152499270eb9e2ac5ed544b551a693f4f/sshuttle-1.3.2.tar.gz"
  sha256 "eeb2eee300a7de16117a86bbb9adb7b0647158edccfb8076f260e0535a439448"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d669edd06d10b4232937eb339b4a8c17a96968625e8afc7991695dd6ccc21923"
  end

  depends_on "python@3.13"

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