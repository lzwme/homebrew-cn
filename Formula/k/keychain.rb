class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://ghfast.top/https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.0.tar.gz"
  sha256 "e55119dc1014a873d3732483c160f4ca925cc39eaa8d8b37ffc6bb789804d45b"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a163ea2b22640e4db4b9a4320e0ee932b4b3a6ccab9513f22363ac54cdb73df8"
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