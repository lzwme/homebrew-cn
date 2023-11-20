class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://ghproxy.com/https://github.com/89luca89/distrobox/archive/refs/tags/1.6.0.tar.gz"
  sha256 "e7b34a4c881e41536fe90307df232ec044fdab55aa80ea2c7c434588193c3460"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "75fd4535287589fa2a0926f87de1a266e542928b7ceea5f3facf6199ed876409"
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