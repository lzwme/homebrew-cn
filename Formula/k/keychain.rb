class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https:www.funtoo.orgKeychain"
  url "https:github.comfuntookeychainarchiverefstags2.9.0.tar.gz"
  sha256 "834e02ba99c20e93aaceba0ec510bd16f2cc0e6e1af56c039d3e57128b52b5ad"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "748f8a82f07cb6d51ca92a8671d6540ad8d5c1834bd31ae3f8f29e2bba57b30d"
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