class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https://docs.gtk.org/glib/"
  url "https://download.gnome.org/sources/glib/2.86/glib-2.86.1.tar.xz"
  sha256 "119d1708ca022556d6d2989ee90ad1b82bd9c0d1667e066944a6d0020e2d5e57"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "1148746fd017ac01e854801f26d7e9837ee389dca780fe691f91735a63530dbf"
    sha256 arm64_sequoia: "69180a746a740205498efc9be52f19c6f200c91700bc1743d6e3dce6dc0cb342"
    sha256 arm64_sonoma:  "319b8baeab0531decb1c1351b77cffe2b9555cb6480d5e8271fd81d6460b2d65"
    sha256 sonoma:        "2468ee427a8741ff97427ef78e4fe90445bb3dd65f4c80e55022b6fa8ed52b7d"
    sha256 arm64_linux:   "690a6e078ec966cb3bf23b07abb9f66f552ed4aaefd7e84190f454f7fe967afd"
    sha256 x86_64_linux:  "f579aed1abac9d64d8b305a01fa2c9e2d0958b9e70973a0564bf0ece34c8e79c"
  end

  depends_on "bison" => :build # for gobject-introspection
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build # for gobject-introspection
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  uses_from_macos "flex" => :build # for gobject-introspection
  uses_from_macos "libffi"
  uses_from_macos "python"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "dbus"
    depends_on "util-linux"
  end

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bin/gdbus-codegen", "bin/glib-genmarshal", "bin/glib-mkenums", "bin/gtester-report"
  link_overwrite "share/glib-2.0/codegen", "share/glib-2.0/gdb"
  # These used to live in `gobject-introspection`
  link_overwrite "lib/girepository-1.0/GLib-2.0.typelib", "lib/girepository-1.0/GModule-2.0.typelib",
                 "lib/girepository-1.0/GObject-2.0.typelib", "lib/girepository-1.0/Gio-2.0.typelib"
  link_overwrite "share/gir-1.0/GLib-2.0.gir", "share/gir-1.0/GModule-2.0.gir",
                 "share/gir-1.0/GObject-2.0.gir", "share/gir-1.0/Gio-2.0.gir"

  resource "gobject-introspection" do
    url "https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz"
    sha256 "920d1a3fcedeadc32acff95c2e203b319039dd4b4a08dd1a2dfd283d19c0b9ae"

    livecheck do
      formula "gobject-introspection"
    end
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/glib/hardcoded-paths.diff"
    sha256 "d846efd0bf62918350da94f850db33b0f8727fece9bfaf8164566e3094e80c97"
  end

  def install
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "gio/meson.build", "install_emptydir(glib_giomodulesdir)", ""

    # build patch for `ld: missing LC_LOAD_DYLIB (must link with at least libSystem.dylib) \
    # in ../gobject-introspection-1.80.1/build/tests/offsets/liboffsets-1.0.1.dylib`
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if OS.mac? && MacOS.version == :ventura

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    # and https://gitlab.gnome.org/GNOME/glib/-/issues/653
    args = %W[
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}/lib/gio/modules
      -Dbsymbolic_functions=false
      -Ddtrace=false
      -Druntime_dir=#{var}/run
      -Dtests=false
    ]

    # Stage build in order to deal with circular dependency as `gobject-introspection`
    # is needed to generate `glib` introspection data used by dependents; however,
    # `glib` is a dependency of `gobject-introspection`.
    # Ref: https://discourse.gnome.org/t/dealing-with-glib-and-gobject-introspection-circular-dependency/18701
    staging_dir = buildpath/"staging"
    staging_meson_args = std_meson_args.map { |s| s.sub prefix, staging_dir }
    system "meson", "setup", "build_staging", "-Dintrospection=disabled", *args, *std_meson_args
    system "meson", "compile", "-C", "build_staging", "--verbose"
    system "meson", "install", "-C", "build_staging"
    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", lib if OS.linux?

    resource("gobject-introspection").stage do
      system "meson", "setup", "build", "-Dcairo=disabled", "-Ddoctool=disabled", *staging_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
    ENV.append_path "PKG_CONFIG_PATH", staging_dir/"lib/pkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", staging_dir/"lib" if OS.linux?
    ENV.append_path "PATH", staging_dir/"bin"

    system "meson", "setup", "build", "--default-library=both", "-Dintrospection=enabled", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib/"pkgconfig/gio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules",
              "giomoduledir=${libdir}/gio/modules"

    (buildpath/"gio/completion/.gitignore").unlink
    bash_completion.install (buildpath/"gio/completion").children
    return unless OS.mac?

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"]
    inreplace lib/"pkgconfig/glib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext.opt_lib} -lintl"
      s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext.opt_include}"
    end
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <glib.h>

      int main(void)
      {
          gchar *result_1, *result_2;
          char *str = "string";

          result_1 = g_convert(str, strlen(str), "ASCII", "UTF-8", NULL, NULL, NULL);
          result_2 = g_convert(result_1, strlen(result_1), "UTF-8", "ASCII", NULL, NULL, NULL);

          return (strcmp(str, result_2) == 0) ? 0 : 1;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}/glib-2.0",
                   "-I#{lib}/glib-2.0/include", "-L#{lib}", "-lglib-2.0"
    system "./test"

    assert_match "This file is generated by glib-mkenum", shell_output(bin/"glib-mkenums")

    (testpath/"net.Corp.MyApp.Frobber.xml").write <<~XML
      <node>
        <interface name="net.Corp.MyApp.Frobber">
          <method name="HelloWorld">
            <arg name="greeting" direction="in" type="s"/>
            <arg name="response" direction="out" type="s"/>
          </method>

          <signal name="Notification">
            <arg name="icon_blob" type="ay"/>
            <arg name="height" type="i"/>
            <arg name="messages" type="as"/>
          </signal>

          <property name="Verbose" type="b" access="readwrite"/>
        </interface>
      </node>
    XML

    system bin/"gdbus-codegen", "--generate-c-code", "myapp-generated",
                                "--c-namespace", "MyApp",
                                "--interface-prefix", "net.corp.MyApp.",
                                "net.Corp.MyApp.Frobber.xml"
    assert_path_exists testpath/"myapp-generated.c"
    assert_match "my_app_net_corp_my_app_frobber_call_hello_world", (testpath/"myapp-generated.h").read

    # Keep (u)int64_t and g(u)int64 aligned. See install comment for details
    (testpath/"typecheck.cpp").write <<~CPP
      #include <cstdint>
      #include <type_traits>
      #include <glib.h>

      int main()
      {
        static_assert(std::is_same<int64_t, gint64>::value == true, "gint64 should match int64_t");
        static_assert(std::is_same<uint64_t, guint64>::value == true, "guint64 should match uint64_t");
        return 0;
      }
    CPP
    system ENV.cxx, "-o", "typecheck", "typecheck.cpp", "-I#{include}/glib-2.0", "-I#{lib}/glib-2.0/include"
  end
end