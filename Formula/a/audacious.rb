class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https:audacious-media-player.org"
  license "BSD-2-Clause"

  stable do
    url "https:distfiles.audacious-media-player.orgaudacious-4.4.2.tar.bz2"
    sha256 "34509504f8c93b370420d827703519f0681136672e42d56335f26f7baec95005"

    resource "plugins" do
      url "https:distfiles.audacious-media-player.orgaudacious-plugins-4.4.2.tar.bz2"
      sha256 "50f494693b6b316380fa718c667c128aa353c01e954cd77a65c9d8aedf18d4bd"
    end
  end

  livecheck do
    url "https:audacious-media-player.orgdownload"
    regex(href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:  "175406bb546a436b6cbda5ebe04b0e5ac50477c1bd58714099f0f01bd6e84b91"
    sha256 arm64_ventura: "46c010fa84f5cafc5fec4a801f90f0c037c281fb22f98704e2ebf115d34f2bf5"
    sha256 sonoma:        "9f957874a1c773d74d0d6d4f3905445bd8aa17b2da8f3283abd78db80cd9e109"
    sha256 ventura:       "1d013dc84b5bf5b5e2ae5d09b8a549bec8894086820fdd2ce08d7c82f5aab107"
    sha256 x86_64_linux:  "40de28638c36168cd3f540c6d01647739fdbffae3850b518e0e49ead956eaaab"
  end

  head do
    url "https:github.comaudacious-media-playeraudacious.git", branch: "master"

    resource "plugins" do
      url "https:github.comaudacious-media-playeraudacious-plugins.git", branch: "master"
    end
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libmodplug"
  depends_on "libnotify"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "opusfile"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "libx11"
    depends_on "libxml2"
    depends_on "pulseaudio"
  end

  def install
    odie "plugins resource needs to be updated" if build.stable? && version != resource("plugins").version

    args = %w[
      -Dgtk=false
    ]

    system "meson", "setup", "build", "-Ddbus=false", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    resource("plugins").stage do
      args += %w[
        -Dmpris2=false
        -Dmac-media-keys=true
      ]

      ENV.prepend_path "PKG_CONFIG_PATH", lib"pkgconfig"
      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  end

  def caveats
    <<~EOS
      audtool does not work due to a broken dbus implementation on macOS, so it is not built.
      GTK+ GUI is not built by default as the Qt GUI has better integration with macOS,
      and the GTK GUI would take precedence if present.
    EOS
  end

  test do
    system bin"audacious", "--help"
  end
end