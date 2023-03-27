class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.3.tar.bz2"
    sha256 "27584dc845c7e70db8c9267990945f17322a1ecc80ff8b452e9ca916a0ce9091"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.3.tar.bz2"
      sha256 "662ef6c8c4bd70d0f35fd1c5f08b91549b9436638b65f8a1a33956b09df89fc6"
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2a756fe8a57417aa55537b2cdd65f2e50664a739ab66d3bd797b31d7f335bac2"
    sha256 arm64_monterey: "8d4a4740672e229459e2f601e4553b849464ff38461bd1854941b43a4a0931b2"
    sha256 arm64_big_sur:  "f15b24a6d5a954f502ebbe5030e47d0e400a8b73a9bc7b84e3122cc18dc7263a"
    sha256 ventura:        "e5855bda267587d3f70fe0ec77a1da489609201ef675e75ad9e93895025e5e0d"
    sha256 monterey:       "314a9048383b80f71c3182bfd7c161e5709d85cf664fc8a28c5e3dfb2ddb4247"
    sha256 big_sur:        "a4d1252e7c7517d884bde70b23c330b32101953e453bba182e99995675befe28"
    sha256 x86_64_linux:   "3d5f0079b4479ed1a50b6f46ef403d99a27b30ea2d23090799d5bd03cf683956"
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git", branch: "master"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git", branch: "master"
    end
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libmodplug"
  depends_on "libnotify"
  depends_on "libopenmpt"
  depends_on "libsamplerate"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "opusfile"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    args = %w[
      -Dgtk=false
      -Dqt6=true
    ]

    system "meson", "setup", "build", *std_meson_args, *args, "-Ddbus=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    resource("plugins").stage do
      args += %w[
        -Dmpris2=false
        -Dmac-media-keys=true
      ]

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "meson", "setup", "build", *std_meson_args, *args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  end

  def caveats
    <<~EOS
      audtool does not work due to a broken dbus implementation on macOS, so it is not built.
      GTK+ GUI is not built by default as the Qt GUI has better integration with macOS, and the GTK GUI would take precedence if present.
    EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end