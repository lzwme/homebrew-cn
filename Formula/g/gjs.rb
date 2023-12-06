class Gjs < Formula
  desc "JavaScript Bindings for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gjs/wikis/Home"
  url "https://download.gnome.org/sources/gjs/1.78/gjs-1.78.1.tar.xz"
  sha256 "7e90511c429127c39eac0068c4ac9a353df7e6fbbc646f5f18e8962882c18641"
  license all_of: ["LGPL-2.0-or-later", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gjs.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "957bfc65e216d2a8f8f1bfea1a1299d17699514225bb70f8509133f6eb3ff33b"
    sha256 arm64_ventura: "28cc748b9ebe6fa9e22a7fd1a2028d5cbc31ab924d50f801e573c1d6bf4dd148"
    sha256 sonoma:        "3e92aaf0184fd004541c4605e36cf184ef4191ef3a560659e34b9365f7e8f2e2"
    sha256 ventura:       "bd2c612d55ad075a96c8d197624355b64e18131b011fa582c305a2cce46664e1"
    sha256 x86_64_linux:  "a6e02bf06361f4964def90a615df530de4ff156f4aca10c36b615f9e030556d3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gobject-introspection"
  depends_on "readline"
  depends_on "spidermonkey"

  fails_with gcc: "5" # meson ERROR: SpiderMonkey sanity check: DID NOT COMPILE

  def install
    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    args = std_meson_args + %w[
      -Dprofiler=disabled
      -Dreadline=enabled
      -Dinstalled_tests=false
      -Dbsymbolic_functions=false
      -Dskip_dbus_tests=true
      -Dskip_gtk_tests=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
    system "#{bin}/gjs", "test.js"
  end
end