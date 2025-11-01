class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://ghfast.top/https://github.com/danielrobbins/keychain/archive/refs/tags/2.9.7.tar.gz"
  sha256 "64a3392dff25fb831d9a24d6aea72637b23291847894450100e2bcffaca7e69a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51ace00c6566e0f5e6fe7c516a4bc19004a1e8504b0abd31f693ad37c16ed4f6"
  end

  def install
    system "make"
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end