class Pipewire < Formula
  desc "Server and user space API to deal with multimedia pipelines"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.1/pipewire-1.6.1.tar.gz"
  sha256 "fe129cab5e5c262f4d8b22a7eba559b5f847e560a4904e8618124eeaca9a579c"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https://gitlab.gnome.org/GNOME/libdex/-/issues/22#note_2368290
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_linux:  "544f1ab162307ccde4b2bc079f713c31d4640cd32045888f5c16d75d3ba05ad6"
    sha256 x86_64_linux: "f78d471efe27b82424ce1f14e573e134cbf27ab24a5dd56ec0fcbfc26c87db53"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "alsa-lib"
  depends_on "dbus"
  depends_on "fftw"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "libsndfile"
  depends_on :linux
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pulseaudio"
  depends_on "readline"
  depends_on "systemd"

  def install
    args = %W[
      -Dexamples=disabled
      -Dtests=disabled
      -Dudevrulesdir=#{lib}/udev/rules.d
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pipewire/pipewire.h>
      #include <assert.h>

      int main() {
        pw_init(NULL, NULL);

        // https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/193384b26aba3917d086ac3f009aa2cab9d197d2/src/pipewire/version.h.in#L25-L27
        assert(pw_check_library_version(PW_MAJOR, PW_MINOR, PW_MICRO));

        pw_deinit();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libpipewire-0.3").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end