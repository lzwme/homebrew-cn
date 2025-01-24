class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https:distrobox.privatedns.org"
  url "https:github.com89luca89distroboxarchiverefstags1.8.1.1.tar.gz"
  sha256 "c27279cbd365f72ee49312015e899ea7113a208432e99840d7c96af904678d39"
  license "GPL-3.0-only"
  head "https:github.com89luca89distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae17941d85ff1e2b2d5689795cd7e389117711727ff33cc4131250c0dc220ebf"
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