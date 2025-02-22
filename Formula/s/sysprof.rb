class Sysprof < Formula
  desc "Statistical, system-wide profiler"
  homepage "https://gitlab.gnome.org/GNOME/sysprof"
  url "https://download.gnome.org/sources/sysprof/47/sysprof-47.2.tar.xz"
  sha256 "e4b5ede9fd978ec3f0d5a0d44d0429a6d201c362bf6cb4527319031ae462c54f"
  # See Debian's Copyright File. https://metadata.ftp-master.debian.org/changelogs//main/s/sysprof/sysprof_47.0-2_copyright
  license all_of: [
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.0-or-later",
    "LGPL-3.0-or-later",
    "BSD-2-Clause-Patent",
    "BSD-3-Clause",
    :public_domain,
  ]
  head "https://gitlab.gnome.org/GNOME/sysprof.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "fa87873eb63a555755113ca2b47a0af3e2d76cdecbcf5067c6113cd3b095e8ba"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libdex"
  depends_on "libpanel"
  depends_on "libunwind"
  depends_on :linux
  depends_on "pango"
  depends_on "polkit"
  depends_on "systemd"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build",
                    "-Dgtk=true",
                    "-Dhelp=false",
                    "-Dtools=true",
                    "-Dtests=false",
                    "-Dexamples=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  def post_install
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    cp pkgshare/"examples/app.c", "."
    flags = shell_output("pkgconf --cflags --libs glib-2.0 sysprof-capture-4").chomp.split
    system ENV.cc, "app.c", "-o", "app", *flags
    assert_equal "SYSPROF_TRACE_FD not found, exiting.", shell_output("./app 2>&1", 1).chomp
  end
end