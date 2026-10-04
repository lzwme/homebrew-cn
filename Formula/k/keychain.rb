class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://ghfast.top/https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.7.tar.gz"
  sha256 "573002c4da81efa27908d197fec7121e5bb7b0018605aa34f345c1cbf7486843"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fa92958abff2ca471ca7d7beb8ab5fdd656ba19b4fd5a8257606fe97eddfc5f"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end