class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://ghfast.top/https://github.com/89luca89/distrobox/archive/refs/tags/1.8.2.0.tar.gz"
  sha256 "c0afc3bac212840ffe3bdb335d0659e0976b0b566a993755f6846e444b9fa40a"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b4c4a0890b72c05cf5b0565912664a38d8eb39cc2b1c2b94f21a2c7ec3e80e4"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  def caveats
    <<~EOS
      Distrobox requires one of podman or docker. Do
        brew install podman
      or consult the documentation for details.
    EOS
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end