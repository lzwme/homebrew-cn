class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://ghproxy.com/https://github.com/89luca89/distrobox/archive/refs/tags/1.6.0.1.tar.gz"
  sha256 "d6b1330b56f6a1bf844c26a27d87f39efd8ae088ed3063f6513d48cf9c18f57e"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a684f87fe0b236051a3676b06c1f2963e90cedfc0b597d243c425eeb8dc2d18"
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