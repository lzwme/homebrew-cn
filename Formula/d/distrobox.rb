class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https:distrobox.privatedns.org"
  url "https:github.com89luca89distroboxarchiverefstags1.7.1.tar.gz"
  sha256 "a39ce0b579e8e7c7599b5effaf53462814d443ce5d30131e19db2f8b830f242f"
  license "GPL-3.0-only"
  head "https:github.com89luca89distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b719b9cfac996037339c4bef32901f16e9e8db42320345cfaa3a7a5311a4e877"
  end

  depends_on :linux

  def install
    system ".install", "--prefix", prefix
  end

  def caveats
    <<~EOS
      Distrobox requires one of podman or docker. Do
        brew install podman
      or consult the documentation for details.
    EOS
  end

  test do
    system bin"distrobox-create", "--dry-run"
  end
end