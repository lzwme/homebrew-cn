class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://ghfast.top/https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.5.tar.gz"
  sha256 "79eacc05c726a836e5c05ff65e2c7f71273e37598fb3e175867cb691b7e001f0"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30eb0c467d8b65999170257d54a8fa045a8f6871cff9977059ee67d92a91401e"
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