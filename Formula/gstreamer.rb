class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]

  stable do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/archive/1.22.3/gstreamer-1.22.3.tar.gz"
    sha256 "8f0db72a22a11527c01895b0aec50174f094c7c772369522350e03f24e87455a"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/gstreamer-1.22.3/gst-plugins-rs-gstreamer-1.22.3.tar.gz"
      sha256 "208f0350471b5e73f1054012732d3609f680ab9d9173dc15b6277560cb224acc"
    end
  end

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "985574ef452faacdeb5b6641529752251a57c427eee309905a9d4f8aff2f9b75"
    sha256 arm64_monterey: "16c060e982488aea66acf43a6e6731553c6d0ad356e907d61803b18be6876f90"
    sha256 arm64_big_sur:  "1835a539635fa37304a600e67808f68d0a95c4c2f7e9d50cca3d7e11e569bae5"
    sha256 ventura:        "de7fbc9e364834f26aac8bc3a3309f996bcf33cde704c60183fc58b655fd045f"
    sha256 monterey:       "57020c43a55d5bd2ecfb95005fa288b8c7d7a259f8a071a6a1313032a2060a44"
    sha256 big_sur:        "4d277270ec510b20cd8b34de6a7ebd40fb7a4365a8f0bc575080feda53656549"
    sha256 x86_64_linux:   "78ddf1a663d0e15b2cc2bc8222740bd40f5b534083f7c5a10d29e1bdf48c4ce3"
  end

  head do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

    resource "rs" do
      url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git", branch: "main"
    end
  end

  depends_on "bison" => :build
  depends_on "cargo-c" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "yasm" => :build
  depends_on "cairo"
  depends_on "dav1d"
  depends_on "faac"
  depends_on "faad2"
  depends_on "fdk-aac"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "gettext"
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libpthread-stubs"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libusrsctp"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "pango"
  depends_on "pygobject3"
  depends_on "python@3.11"
  depends_on "rav1e"
  depends_on "rtmpdump"
  depends_on "speex"
  depends_on "srtp"
  depends_on "taglib"
  depends_on "theora"
  depends_on "x264"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "freeglut"
  end

  def python3
    which("python3.11")
  end

  # These paths used to live in various `gst-*` formulae.
  link_overwrite "bin/gst-*", "lib/ligst*", "lib/libges*", "lib/girepository-1.0/Gst*-1.0.typelib"
  link_overwrite "lib/girepository-1.0/GES-1.0.typelib", "lib/gst-validate-launcher/*", "lib/gstreamer-1.0/*"
  link_overwrite "lib/pkgconfig/gst*.pc", "lib/python3.11/site-packages/gi/overrides/*", "include/gstreamer-1.0/*"
  link_overwrite "share/gir-1.0/Gst*.gir", "share/gir-1.0/GES-1.0.gir", "share/gstreamer-1.0/*"
  link_overwrite "share/locale/*/LC_MESSAGES/gst-*.mo", "share/man/man1/g*"

  # Avoid overlinking of `gst-python` python extension module.
  # https://gitlab.freedesktop.org/gstreamer/gst-python/-/merge_requests/41
  # TODO: Migrate patch to gstreamer monorepo.
  patch :DATA

  def install
    (buildpath/"subprojects/gst-plugins-rs").install resource("rs")
    site_packages = Language::Python.site_packages(python3)
    # To pass arguments to subprojects (e.g. `gst-editing-services`), use
    #   -Dsubproject:option=value
    args = %W[
      -Dpython=enabled
      -Dlibav=enabled
      -Dlibnice=disabled
      -Dbase=enabled
      -Dgood=enabled
      -Dugly=enabled
      -Dbad=enabled
      -Ddevtools=enabled
      -Dges=enabled
      -Drtsp_server=enabled
      -Drs=enabled
      -Dtls=enabled
      -Dqt5=disabled
      -Dtools=enabled
      -Dorc-source=system
      -Dgpl=enabled
      -Dtests=disabled
      -Dexamples=disabled
      -Dnls=enabled
      -Dorc=enabled
      -Ddoc=disabled
      -Dgtk_doc=disabled
      -Dintrospection=enabled
      -Dpackage-origin=#{tap.default_remote}
      -Dgst-devtools:validate=enabled
      -Dgst-devtools:cairo=enabled
      -Dgst-editing-services:pygi-overrides-dir=#{site_packages}/gi/overrides
      -Dgst-python:pygi-overrides-dir=#{site_packages}/gi/overrides
      -Dgst-python:python=#{python3}
      -Dgst-plugins-bad:sctp=enabled
      -Dgst-plugins-bad:sctp-internal-usrsctp=disabled
      -Dgst-plugins-good:soup=enabled
      -Dgst-plugins-rs:closedcaption=enabled
      -Dgst-plugins-rs:dav1d=enabled
      -Dgst-plugins-rs:sodium=enabled
      -Dgst-plugins-rs:csound=disabled
      -Dgst-plugins-rs:gtk4=enabled
      -Dgst-plugins-rs:sodium-source=system
    ]

    # The apple media plug-in uses API that was added in Mojave
    args << "-Dgst-plugins-bad:applemedia=disabled" if MacOS.version <= :high_sierra

    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args << "-Dgstreamer:ptp-helper-permissions=none"

    # Prevent the build from downloading an x86-64 version of bison.
    inreplace "meson.build", "subproject('macos-bison-binary')", ""

    # Set `RPATH` since `cargo-c` doesn't seem to.
    # https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/issues/279
    plugin_dir = lib/"gstreamer-1.0"
    rpath_args = [loader_path, rpath(source: plugin_dir)].map { |path| "-rpath,#{path}" }
    ENV["RUSTFLAGS"] = "--codegen link-args=-Wl,#{rpath_args.join(",")}"

    # Make sure the `openssl-sys` crate uses our OpenSSL.
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      All gst-* GStreamer plugins are now bundled in this formula.
      For GStreamer to find your own plugins, add their paths to `GST_PLUGIN_PATH`.
      For example, if you have plugins in `~/.local/lib/gstreamer-1.0`:
        export GST_PLUGIN_PATH="~/.local/lib/gstreamer-1.0"

      Do not install plugins into GStreamer's prefix. They will be deleted
      by `brew upgrade`.
    EOS
  end

  test do
    assert_equal version, resource("rs").version,
                 "The `rs` resource should use the tag matching the `gstreamer` version!"

    # TODO: Improve test according to suggestions at
    #   https://github.com/orgs/Homebrew/discussions/3740
    system bin/"gst-inspect-1.0"
    system bin/"gst-validate-launcher", "--usage"
    system bin/"ges-launch-1.0", "--ges-version"
    system bin/"gst-inspect-1.0", "libav"
    system bin/"gst-inspect-1.0", "--plugin", "dvbsuboverlay"
    system bin/"gst-inspect-1.0", "--plugin", "fdkaac"
    system bin/"gst-inspect-1.0", "--plugin", "volume"
    system bin/"gst-inspect-1.0", "--plugin", "cairo"
    system bin/"gst-inspect-1.0", "--plugin", "dvdsub"
    system bin/"gst-inspect-1.0", "--plugin", "x264"
    system bin/"gst-inspect-1.0", "--plugin", "rtspclientsink"
    system bin/"gst-inspect-1.0", "--plugin", "rsfile"

    system python3, "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end

__END__
diff --git a/subprojects/gst-python/gi/overrides/meson.build b/subprojects/gst-python/gi/overrides/meson.build
index 5977ee3..1b399af 100644
--- a/subprojects/gst-python/gi/overrides/meson.build
+++ b/subprojects/gst-python/gi/overrides/meson.build
@@ -3,13 +3,20 @@ install_data(pysources,
     install_dir: pygi_override_dir,
     install_tag: 'python-runtime')
 
+# avoid overlinking
+if host_machine.system() == 'windows'
+    python_ext_dep = python_dep
+else
+    python_ext_dep = python_dep.partial_dependency(compile_args: true)
+endif
+
 gstpython = python.extension_module('_gi_gst',
     sources: ['gstmodule.c'],
     install: true,
     install_dir : pygi_override_dir,
     install_tag: 'python-runtime',
     include_directories : [configinc],
-    dependencies : [gst_dep, python_dep, pygobject_dep])
+    dependencies : [gst_dep, python_ext_dep, pygobject_dep])
 
 env = environment()
 env.prepend('_GI_OVERRIDES_PATH', [