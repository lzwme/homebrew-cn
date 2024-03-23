class Glib < Formula
  include Language::Python::Shebang

  desc "Core application library for C"
  homepage "https:developer.gnome.orgglib"
  url "https:download.gnome.orgsourcesglib2.80glib-2.80.0.tar.xz"
  sha256 "8228a92f92a412160b139ae68b6345bd28f24434a7b5af150ebe21ff587a561d"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "aa44de729d2a822013b8466aac7b5bf9fd05a2cb30be6417d46a6bfb5681d789"
    sha256 arm64_ventura:  "4fbe903dc8bd989384cb7c9fb78e3c36d8a5f29f7e48ce289c48bd42b52f51f1"
    sha256 arm64_monterey: "508a98f46f737a0c45b777124d51123313805f8fa8354645542ef5973ce28810"
    sha256 sonoma:         "b1bd1a9384825561f54870aff0f5f3d4e2d5670dc6562fbda956090d447321f3"
    sha256 ventura:        "904e5feef4f8d753cf9fae04b1659e42cb3c29c26b9c0ec054bfb44d792aeafd"
    sha256 monterey:       "c1020494efbf833c6504f7ae92f18f8238aca0d9cdf1722660a37a5f700b3c4e"
    sha256 x86_64_linux:   "2f7670c6ca1eda7a4a3ef12cb1599a8ab8139add55188b05db08af1a39fe4b62"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre2"
  depends_on "python@3.12"

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

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  # replace several hardcoded paths with homebrew counterparts
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches43467fd8dfc0e8954892ecc08fab131242dca025glibhardcoded-paths.diff"
    sha256 "d81c9e8296ec5b53b4ead6917f174b06026eeb0c671dfffc4965b2271fb6a82c"
  end

  def install
    inreplace %w[gioxdgmimexdgmime.c glibgutils.c], "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX
    # Avoid the sandbox violation when an empty directory is created outside of the formula prefix.
    inreplace "giomeson.build", "install_emptydir(glib_giomodulesdir)", ""

    # We don't use a venv as virtualenv_create runs `ENV.refurbish_args`. This causes `gint64`
    # to be detected as `long` rather than `long long` on macOS which mismatches with `int64_t`.
    # Although documented as valid (https:docs.gtk.orgglibtypes.html#gint64), it can cause
    # ABI breakage if type changes between releases (e.g. seen in `glibmm@2.66`) and it breaks
    # assumptions made by some dependents. Also, GNOME prefers equivalence of types but cannot
    # require it due to ABI impact - https:gitlab.gnome.orgGNOMEglib-merge_requests2841
    resource("packaging").stage do
      system "python3.12", "-m", "pip", "install", "--target", share"glib-2.0",
                                                   *std_pip_args(prefix: false, build_isolation: true), "."
    end
    ENV.prepend_path "PYTHONPATH", share"glib-2.0"

    # Disable dtrace; see https:trac.macports.orgticket30413
    # and https:gitlab.gnome.orgGNOMEglib-issues653
    args = %W[
      --default-library=both
      --localstatedir=#{var}
      -Dgio_module_dir=#{HOMEBREW_PREFIX}libgiomodules
      -Dbsymbolic_functions=false
      -Ddtrace=false
      -Druntime_dir=#{var}run
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be
    # used by glib-networking and glib-openssl to determine where to install
    # their modules
    inreplace lib"pkgconfiggio-2.0.pc",
              "giomoduledir=#{HOMEBREW_PREFIX}libgiomodules",
              "giomoduledir=${libdir}giomodules"

    if OS.mac?
      # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
      # have a pkgconfig file, so we add gettext lib and include paths here.
      gettext = Formula["gettext"].opt_prefix
      inreplace lib"pkgconfigglib-2.0.pc" do |s|
        s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
                "Libs: -L${libdir} -lglib-2.0 -L#{gettext}lib -lintl"
        s.gsub! "Cflags: -I${includedir}glib-2.0 -I${libdir}glib-2.0include",
                "Cflags: -I${includedir}glib-2.0 -I${libdir}glib-2.0include -I#{gettext}include"
      end

      if MacOS.version < :catalina
        # `pkg-config --print-requires-private gobject-2.0` includes libffi,
        # but that package is keg-only so it needs to look for the pkgconfig file
        # in libffi's opt path.
        libffi = Formula["libffi"].opt_prefix
        inreplace lib"pkgconfiggobject-2.0.pc" do |s|
          s.gsub! "Requires.private: libffi",
                  "Requires.private: #{libffi}libpkgconfiglibffi.pc"
        end
      end
    end

    rm "giocompletion.gitignore"
    bash_completion.install (buildpath"giocompletion").children
    rewrite_shebang detected_python_shebang, *bin.children
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

    assert_match "This file is generated by glib-mkenum", shell_output("#{bin}glib-mkenums")

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