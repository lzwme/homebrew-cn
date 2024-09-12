class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  # TODO: Move to latest `spidermonkey` on 1.82.x.
  # Also set deprecation date on `spidermonkey@115`.
  url "https://download.gnome.org/sources/gjs/1.80/gjs-1.80.2.tar.xz"
  sha256 "135e39c5ac591096233e557cfe577d64093f5054411d47cb2e214bad7d4199bd"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "2d308a342983eb5788b96a27c46612ff4d23dc213d8f1846cda4a448d015ddef"
    sha256 arm64_sonoma:   "307d4320f5578aa3c533d3a88225ee48b2e76bc11d86968588fa9b56868ec566"
    sha256 arm64_ventura:  "174e50c45c543ca5a0c38c0f0cf91b54282789e7d61e0e915dcf81669908f1ab"
    sha256 arm64_monterey: "340bd07ecaaae88d11557c1f279ef58f1ebd586d92815b6c8cd11ff573fa3864"
    sha256 sonoma:         "d439ca01cec06fda0e44a89f18d4d1c1cdc34b09dd19c1e971bd1606456741bc"
    sha256 ventura:        "897dbcdc07cc28f13120ad285101f3460876545923b4d0142498fe778d4cc048"
    sha256 monterey:       "55382641f05e45a654fd48d2bba55701b8baca4e7521559e0d3c1facfd2577fe"
    sha256 x86_64_linux:   "30705604f5ba1f63011f8fb269f56320e25d3d42b2c674717d8fcaab6139b62a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "libx11"
  depends_on "readline"
  depends_on "spidermonkey@115"

  uses_from_macos "libffi"

  on_macos do
    depends_on "gettext"
  end

  fails_with gcc: "5" # meson ERROR: SpiderMonkey sanity check: DID NOT COMPILE

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dprofiler=disabled
      -Dreadline=enabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.js").write <<~EOS
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
      if (31 != GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
        imports.system.exit(1)
    EOS
    system bin/"gjs", "test.js"
  end
end