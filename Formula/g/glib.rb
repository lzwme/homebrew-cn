class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https:docs.gtk.orgglib"
  url "https:download.gnome.orgsourcesglib2.82glib-2.82.1.tar.xz"
  sha256 "478634440bf52ee4ec4428d558787398c0be6b043c521beb308334b3db4489a6"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "f2abd982579380fa01cf4bde3fba4e4e8c3f637968ed5f877abe9b2f03867546"
    sha256 arm64_sonoma:  "59b2f7c8083f75518cf7389076d53273da8dd3408b64c96d16b1b98a4fcfbfd5"
    sha256 arm64_ventura: "03f99542d1f48c8f4a3219523ea4dcd854959a45d5024b69fb9fed312cfc03ab"
    sha256 sonoma:        "4d6212217fd522c5771a970cf836090ac0e61dc8e71fc87348bb02f16133d1de"
    sha256 ventura:       "3a1546e0953f0dc82f81a8bcff6d0a58ec12cc646532ae7682313e4b8c0a19fd"
    sha256 x86_64_linux:  "5ab4a7c3a7b616b4a472fde55d9341fb65d048258b6d63a85b4005fc85a4652b"
  end

  depends_on "bison" => :build # for gobject-introspection
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build # for gobject-introspection
  depends_on "pcre2"
  depends_on "python-packaging"
  depends_on "python@3.13"

  uses_from_macos "flex" => :build # for gobject-introspection
  uses_from_macos "libffi", since: :catalina

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "dbus"
    depends_on "util-linux"
  end

  # These used to live in the now defunct `glib-utils`.
  link_overwrite "bingdbus-codegen", "binglib-genmarshal", "binglib-mkenums", "bingtester-report"
  link_overwrite "shareglib-2.0codegen", "shareglib-2.0gdb"
  # These used to live in `gobject-introspection`
  link_overwrite "libgirepository-1.0GLib-2.0.typelib", "libgirepository-1.0GModule-2.0.typelib",
                 "libgirepository-1.0GObject-2.0.typelib", "libgirepository-1.0Gio-2.0.typelib"
  link_overwrite "sharegir-1.0GLib-2.0.gir", "sharegir-1.0GModule-2.0.gir",
                 "sharegir-1.0GObject-2.0.gir", "sharegir-1.0Gio-2.0.gir"

  resource "gobject-introspection" do
    url "https:download.gnome.orgsourcesgobject-introspection1.82gobject-introspection-1.82.0.tar.xz"
    sha256 "0f5a4c1908424bf26bc41e9361168c363685080fbdb87a196c891c8401ca2f09"
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches43467fd8dfc0e8954892ecc08fab131242dca025glibhardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    python = "python3.13"
    inreplace %w[gioxdgmimexdgmime.c glibgutils.c], "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "giomeson.build", "install_emptydir(glib_giomodulesdir)", ""

    python_packaging_site_packages = Formula["python-packaging"].opt_prefixLanguage::Python.site_packages(python)
    (share"glib-2.0").install_symlink python_packaging_site_packages.children

    # build patch for `ld: missing LC_LOAD_DYLIB (must link with at least libSystem.dylib) \
    # in ..gobject-introspection-1.80.1buildtestsoffsetsliboffsets-1.0.1.dylib`
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if OS.mac? && MacOS.version == :ventura

    # Disable dtrace; see https:trac.macports.orgticket30413
    # and https:gitlab.gnome.orgGNOMEglib-issues653
    args = %W[
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}libgiomodules
      -Dbsymbolic_functions=false
      -Ddtrace=false
      -Druntime_dir=#{var}run
      -Dtests=false
    ]

    # Stage build in order to deal with circular dependency as `gobject-introspection`
    # is needed to generate `glib` introspection data used by dependents; however,
    # `glib` is a dependency of `gobject-introspection`.
    # Ref: https:discourse.gnome.orgtdealing-with-glib-and-gobject-introspection-circular-dependency18701
    staging_dir = buildpath"staging"
    staging_meson_args = std_meson_args.map { |s| s.sub prefix, staging_dir }
    system "meson", "setup", "build_staging", "-Dintrospection=disabled", *args, *staging_meson_args
    system "meson", "compile", "-C", "build_staging", "--verbose"
    system "meson", "install", "-C", "build_staging"
    ENV.append_path "PKG_CONFIG_PATH", staging_dir"libpkgconfig"
    ENV.append_path "LD_LIBRARY_PATH", staging_dir"lib" if OS.linux?
    resource("gobject-introspection").stage do
      system "meson", "setup", "build", "-Dcairo=disabled", "-Ddoctool=disabled", *staging_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
    ENV.append_path "PATH", staging_dir"bin"

    system "meson", "setup", "build", "--default-library=both", "-Dintrospection=enabled", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib"pkgconfiggio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}libgiomodules",
              "giomoduledir=${libdir}giomodules"

    (buildpath"giocompletion.gitignore").unlink
    bash_completion.install (buildpath"giocompletion").children
    rewrite_shebang detected_python_shebang, *bin.children
    return unless OS.mac?

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"]
    inreplace lib"pkgconfigglib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext.opt_lib} -lintl"
      s.gsub! "Cflags: -I${includedir}glib-2.0 -I${libdir}glib-2.0include",
              "Cflags: -I${includedir}glib-2.0 -I${libdir}glib-2.0include -I#{gettext.opt_include}"
    end
    return if MacOS.version >= :catalina

    # `pkg-config --print-requires-private gobject-2.0` includes libffi,
    # but that package is keg-only so it needs to look for the pkgconfig file
    # in libffi's opt path.
    inreplace lib"pkgconfiggobject-2.0.pc",
              "Requires.private: libffi",
              "Requires.private: #{Formula["libffi"].opt_lib}pkgconfiglibffi.pc"
  end

  def post_install
    (HOMEBREW_PREFIX"libgiomodules").mkpath
  end

  test do
    (testpath"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}glib-2.0",
                   "-I#{lib}glib-2.0include", "-L#{lib}", "-lglib-2.0"
    system ".test"

    assert_match "This file is generated by glib-mkenum", shell_output(bin"glib-mkenums")

    (testpath"net.Corp.MyApp.Frobber.xml").write <<~EOS
      <node>
        <interface name="net.Corp.MyApp.Frobber">
          <method name="HelloWorld">
            <arg name="greeting" direction="in" type="s">
            <arg name="response" direction="out" type="s">
          <method>

          <signal name="Notification">
            <arg name="icon_blob" type="ay">
            <arg name="height" type="i">
            <arg name="messages" type="as">
          <signal>

          <property name="Verbose" type="b" access="readwrite">
        <interface>
      <node>
    EOS

    system bin"gdbus-codegen", "--generate-c-code", "myapp-generated",
                                "--c-namespace", "MyApp",
                                "--interface-prefix", "net.corp.MyApp.",
                                "net.Corp.MyApp.Frobber.xml"
    assert_predicate testpath"myapp-generated.c", :exist?
    assert_match "my_app_net_corp_my_app_frobber_call_hello_world", (testpath"myapp-generated.h").read

    # Keep (u)int64_t and g(u)int64 aligned. See install comment for details
    (testpath"typecheck.cpp").write <<~EOS
      #include <cstdint>
      #include <type_traits>
      #include <glib.h>

      int main()
      {
        static_assert(std::is_same<int64_t, gint64>::value == true, "gint64 should match int64_t");
        static_assert(std::is_same<uint64_t, guint64>::value == true, "guint64 should match uint64_t");
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "typecheck", "typecheck.cpp", "-I#{include}glib-2.0", "-I#{lib}glib-2.0include"
  end
end