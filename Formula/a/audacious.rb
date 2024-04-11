class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https:audacious-media-player.org"
  license "BSD-2-Clause"
  revision 1

  stable do
    url "https:distfiles.audacious-media-player.orgaudacious-4.3.1.tar.bz2"
    sha256 "85e9e26841505b51e342ee72a2d05f19bef894f567a029ebb3f3e0c1adb42042"

    resource "plugins" do
      url "https:distfiles.audacious-media-player.orgaudacious-plugins-4.3.1.tar.bz2"
      sha256 "2dea26e3af583a2d684df240b27b2b2932bcd653df4db500a85f4fe5d5fdc8a6"
    end

    # Fixes: ..srclibaudcorevfs.h:78:62: error: integer value -1 is outside
    # the valid range of values [0, 3] for this enumeration type
    # [-Wenum-constexpr-conversion]
    # Remove when included in a release.
    patch do
      url "https:github.comaudacious-media-playeraudaciouscommit4967240899b6f36e3e5dfc68f1b8963824562fe9.patch?full_index=1"
      sha256 "f1232ab272927c4d042e2475d02d08e99965b5f01a5a1a7c57a76c669224d688"
    end
  end

  livecheck do
    url "https:audacious-media-player.orgdownload"
    regex(href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "82cf7e48a09f0468ccd17fd84b03321d63cc54fbf740baacea47f1061fd21000"
    sha256 arm64_ventura:  "7c035f0fe808ddb565fe00cc7268aa317ae965cd0fdcfa821dffee0e52904fca"
    sha256 arm64_monterey: "2b20f6790d06b5c477dcbf760e50d9f15ba55922c74910e54179c4c180384f70"
    sha256 sonoma:         "db478a7d9dae10ad8b9743cb4c96a4164a62495896ac13b1eb8cf677652eb1a7"
    sha256 ventura:        "ca18e033d72a4c6ee60b5b7127921b394b2e5c2bf88f69648ed0abf5479260ab"
    sha256 monterey:       "73d8752361d84d876ef26d68e8003b62ee46d6db7facf7ffb3a931bacf3b0594"
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

      ENV.prepend_path "PKG_CONFIG_PATH", lib"pkgconfig"
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
    system bin"audacious", "--help"
  end
end