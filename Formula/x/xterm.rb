class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-388.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_388.orig.tar.gz"
  sha256 "ac429345e6f937a5945a89d425a265fee6c215fc669dbdc6a0326e21f4c5f674"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e6c527dc4eba88d2a5be78dc5c79040f0af1fffbd807a0b9b3810891607ad740"
    sha256 arm64_ventura:  "b20bc8b02cb12f6d350c457ec203aa2bd4f478712987a7bce86fb93d408f619c"
    sha256 arm64_monterey: "e4071eba638b56c17d49ab4ce3aeeb5b4942ed541c180760a0df4d15a6157cc7"
    sha256 sonoma:         "8ec848d18542b4ad7d5a3871a6830a215b6f109ceabd4e5d221dd279b57c2354"
    sha256 ventura:        "5f11f0c41430447e74514193a879dc1a8e3ca51a12ff0a48953ec0583cbc6e4f"
    sha256 monterey:       "a668a50d9803a1ee2e26c59efaffc3349e3ba7de60073047e86100630f246f67"
    sha256 x86_64_linux:   "d6ad40db66f998b75c817ec6d81a6246ed75113c1e11f80f69559ae1fde5e990"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end