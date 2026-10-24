class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://ghfast.top/https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.8.tar.gz"
  sha256 "66bf1a3e3887b924a7649fbf4a72b4982a5345fdfb634ffffd772085e2ba72da"
  license "GPL-3.0-only"
  head "https://github.com/danielrobbins/keychain.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15c6f195c141fc755953d3478b0980af2ed0f7cda1ca17cd82c3b0f4a980227f"
  end

  depends_on "python@3.15"

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