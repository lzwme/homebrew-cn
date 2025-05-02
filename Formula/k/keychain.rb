class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https:www.funtoo.orgKeychain"
  url "https:github.comfuntookeychainarchiverefstags2.9.1.tar.gz"
  sha256 "49e7bec7495cf79300a23ad13fbdd7c2083f823c7dac2c1333bd70e8bfd83d8d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2c7d19cb924412c874cdf963b2d99186d257199fab4bbd3320f0c5d8d05aeec"
  end

  def install
    system "make"
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system bin"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath".keychain#{hostname}-sh")
    system bin"keychain", "--stop", "mine"
  end
end