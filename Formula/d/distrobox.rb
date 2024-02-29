class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https:distrobox.privatedns.org"
  url "https:github.com89luca89distroboxarchiverefstags1.7.0.tar.gz"
  sha256 "ede6267a4e26c43535622e0ca3b27bc35bdeb5cbc97e551f094b852447457200"
  license "GPL-3.0-only"
  head "https:github.com89luca89distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e83156f5b1384e7463a2534eb4897c565e80ad6f5518f8df6bbdcbf9ffd16338"
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