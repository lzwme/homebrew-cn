class Netaddr < Formula
  include Language::Python::Virtualenv

  desc "Network address manipulation library"
  homepage "https:netaddr.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages5490188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229dnetaddr-1.3.0.tar.gz"
  sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  license "BSD-3-Clause"
  head "https:github.comnetaddrnetaddr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a7284179680caf2362b7b59aece0fd13ce71d9ee590609b68c8706b0baf8671c"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output(bin"netaddr info 10.0.0.016")
    assert_match "Usable addresses         65534", output
  end
end