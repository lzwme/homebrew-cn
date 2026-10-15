class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/tarballs/profanity-0.18.2.tar.xz"
  sha256 "46964928742733fffcf8ca65d37ac0874c8ccd6270cbc065cb1013cee94e9e3b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/profanity-im/profanity.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "eb904149c89e86e2b5d917ad75f018e73f46a2c99a13b1161ecf882c76e08ee3"
    sha256 arm64_tahoe:       "0182b0cf01532bd56387a01661a39d939d6b89ab961962713452a68011dbdd36"
    sha256 arm64_sequoia:     "5f31183e7b7cdd078eb8356838a7cf283a1f40c745ffbefc8f4e65f69d4d7450"
    sha256 arm64_linux:       "55bcb058aa241607fff75fe87c62be2ef1de5961ca00d8aa7814f5d46893630b"
    sha256 x86_64_linux:      "76f694ca9b9d86f8ce53fc18126d1efe32549c3089a56706972315457c266708"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+3"
  depends_on "libgcrypt"
  depends_on "libomemo-c"
  depends_on "libotr"
  depends_on "libstrophe"
  depends_on "libx11"
  depends_on "libxscrnsaver"
  depends_on "python@3.15"
  depends_on "qrencode"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    # Meson shells out to `brew --prefix readline` on macOS if `dependency("readline")`
    # cannot resolve directly, so keep Homebrew's `brew` executable discoverable.
    ENV.prepend_path "PATH", File.dirname(HOMEBREW_BREW_FILE)

    args = %w[
      -Dnotifications=enabled
      -Dpython-plugins=enabled
      -Dc-plugins=enabled
      -Dotr=enabled
      -Dpgp=enabled
      -Domemo=enabled
      -Domemo-backend=libomemo-c
      -Domemo-qrcode=enabled
      -Dicons-and-clipboard=enabled
      -Dgdk-pixbuf=enabled
      -Dxscreensaver=enabled
    ]

    system "meson", "setup", "build", *std_meson_args, *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"profanity", "-v"
  end
end