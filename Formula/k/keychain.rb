class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https:www.funtoo.orgKeychain"
  url "https:github.comfuntookeychainarchiverefstags2.9.4.tar.gz"
  sha256 "c233cbb676d72d07c5c7e65ec472a55eae089e5bfa81e0b2714f9cb125835905"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3560662259f9289c4dc58390e603855d68f68e69bfa0c23f2553bd8c738e50d9"
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