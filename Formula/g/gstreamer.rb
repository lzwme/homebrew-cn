class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https:gstreamer.freedesktop.org"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]

  stable do
    url "https:gitlab.freedesktop.orggstreamergstreamer-archive1.24.5gstreamer-1.24.5.tar.bz2"
    sha256 "1fae9176cc2845f82539961176dc9b01f7bb853649be4e01bd18fe49aee61fcc"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https:gitlab.freedesktop.orggstreamergst-plugins-rs-archivegstreamer-1.24.5gst-plugins-rs-gstreamer-1.24.5.tar.bz2"
      sha256 "709ba5da5f24a550b2cc76806967680304d9ec0aba528f06274685f1664dd107"

      # Backport support for newer `dav1d`
      # upstream commit ref, https:gitlab.freedesktop.orggstreamergst-plugins-rs-commit7e1ab086de00125bc0d596f9ec5d74c9b82b2cc0
      patch do
        url "https:raw.githubusercontent.comHomebrewformula-patches4c27cd2be8cf074845c7a839af5d16acc646e368gstreamergst-plugins-rs-dav1d.patch"
        sha256 "a52e0ceb83c57ce6b2080d9b814e24c7382ffb607241add77f5a5f58b2c3582b"
      end
    end
  end

  livecheck do
    url "https:gstreamer.freedesktop.orgsrcgstreamer"
    regex(href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "c8ffb1546a087ce4e9a389691f636fe195651020640432d8d1cc5794ad55c7fb"
    sha256 arm64_ventura:  "8bdcb149752892397d55ed6aa74a03b75415e6020733a9aedd09a94fd43df7de"
    sha256 arm64_monterey: "ae7df1b4f363a2a3e5829937ce25e0b4768296eca916bf152b6ef89ccdb116a0"
    sha256 sonoma:         "4e266ecce4b0c33b9aec94e04e1b2007ae8c01a647ddb2c49c5e20eb3d17816e"
    sha256 ventura:        "8f53a236db84738c592d84cd09ce902fcd34c17d4971b4c561b57bf7efc596e4"
    sha256 monterey:       "513d0c62b9bc5d8101bf75f68d19527d1863a0da7e28624456e8bf35c42fa884"
    sha256 x86_64_linux:   "52658aec6cb318432ba4a4456deee520260f36f5dcc28365028e09d20645b158"
  end

  head do
    url "https:gitlab.freedesktop.orggstreamergstreamer.git", branch: "main"

    resource "rs" do
      url "https:gitlab.freedesktop.orggstreamergst-plugins-rs.git", branch: "main"
    end
  end

  depends_on "bison" => :build
  depends_on "cargo-c" => :build
  depends_on "gitlint" => :build
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
  depends_on "ffmpeg@6"
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
  depends_on "libsodium"
  depends_on "libsoup"
  depends_on "libusrsctp"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "openexr"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "orc"
  depends_on "pango"
  depends_on "pygobject3"
  depends_on "python@3.12"
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
    # https:github.comHomebrewhomebrew-corepull92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "freeglut"
  end

  def python3
    which("python3.12")
  end

  # These paths used to live in various `gst-*` formulae.
  link_overwrite "bingst-*", "libligst*", "liblibges*", "libgirepository-1.0Gst*-1.0.typelib"
  link_overwrite "libgirepository-1.0GES-1.0.typelib", "libgst-validate-launcher*", "libgstreamer-1.0*"
  link_overwrite "libpkgconfiggst*.pc", "libpython3.12site-packagesgioverrides*", "includegstreamer-1.0*"
  link_overwrite "sharegir-1.0Gst*.gir", "sharegir-1.0GES-1.0.gir", "sharegstreamer-1.0*"
  link_overwrite "sharelocale*LC_MESSAGESgst-*.mo", "sharemanman1g*"

  # Avoid overlinking of `gst-python` python extension module.
  # https:gitlab.freedesktop.orggstreamergst-python-merge_requests41
  # TODO: Migrate patch to gstreamer monorepo.
  patch :DATA

  def install
    odie "rs resource needs to be updated" if build.stable? && version != resource("rs").version

    (buildpath"subprojectsgst-plugins-rs").install resource("rs")

    site_packages = Language::Python.site_packages(python3)
    # To pass arguments to subprojects (e.g. `gst-editing-services`), use
    #   -Dsubproject:option=value
    args = %W[
      -Dpython.platlibdir=#{site_packages}
      -Dpython.purelibdir=#{site_packages}
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
      -Dgst-editing-services:pygi-overrides-dir=#{site_packages}gioverrides
      -Dgst-python:pygi-overrides-dir=#{site_packages}gioverrides
      -Dgst-python:python=#{python3}
      -Dgst-plugins-bad:opencv=disabled
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
    args << "-Dgst-plugins-bad:applemedia=disabled" if OS.mac? && MacOS.version <= :high_sierra

    # Ban trying to chown to root.
    # https:bugzilla.gnome.orgshow_bug.cgi?id=750367
    args << "-Dgstreamer:ptp-helper-permissions=none"

    # Prevent the build from downloading an x86-64 version of bison.
    args << "-Dbuild-tools-source=system"

    # Set `RPATH` since `cargo-c` doesn't seem to.
    # https:gitlab.freedesktop.orggstreamergst-plugins-rs-issues279
    plugin_dir = lib"gstreamer-1.0"
    rpath_args = [loader_path, rpath(source: plugin_dir)].map { |path| "-rpath,#{path}" }
    ENV["RUSTFLAGS"] = "--codegen link-args=-Wl,#{rpath_args.join(",")}"
    inreplace "subprojectsgst-plugins-rscargo_wrapper.py",
              "env['RUSTFLAGS'] = shlex_join(rust_flags)",
              "env['RUSTFLAGS'] = ' '.join(rust_flags)"

    # Make sure the `openssl-sys` crate uses our OpenSSL.
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      All gst-* GStreamer plugins are now bundled in this formula.
      For GStreamer to find your own plugins, add their paths to `GST_PLUGIN_PATH`.
      For example, if you have plugins in `~.locallibgstreamer-1.0`:
        export GST_PLUGIN_PATH="~.locallibgstreamer-1.0"

      Do not install plugins into GStreamer's prefix. They will be deleted
      by `brew upgrade`.
    EOS
  end

  test do
    # TODO: Improve test according to suggestions at
    #   https:github.comorgsHomebrewdiscussions3740
    system bin"gst-inspect-1.0"
    # system bin"gst-validate-launcher", "--usage" # disabled until 3.12 is made the default python
    system bin"ges-launch-1.0", "--ges-version"
    system bin"gst-inspect-1.0", "libav"
    system bin"gst-inspect-1.0", "--plugin", "dvbsuboverlay"
    system bin"gst-inspect-1.0", "--plugin", "fdkaac"
    system bin"gst-inspect-1.0", "--plugin", "volume"
    system bin"gst-inspect-1.0", "--plugin", "cairo"
    system bin"gst-inspect-1.0", "--plugin", "dvdsub"
    system bin"gst-inspect-1.0", "--plugin", "x264"
    system bin"gst-inspect-1.0", "--plugin", "rtspclientsink"
    system bin"gst-inspect-1.0", "--plugin", "rsfile"
    system bin"gst-inspect-1.0", "hlsdemux2"

    system python3, "-c", <<~EOS
      import gi
      gi.require_version('Gst', '1.0')
      from gi.repository import Gst
      print (Gst.Fraction(num=3, denom=5))
    EOS
  end
end

__END__
diff --git asubprojectsgst-pythongioverridesmeson.build bsubprojectsgst-pythongioverridesmeson.build
index 20aeb06ac9..3c53eab6d7 100644
--- asubprojectsgst-pythongioverridesmeson.build
+++ bsubprojectsgst-pythongioverridesmeson.build
@@ -7,8 +7,10 @@ python.install_sources(pysources,
 host_system = host_machine.system()
 if host_system == 'windows'
   gst_dep_for_gi = gst_dep
+  python_ext_dep = python_dep
 else
   gst_dep_for_gi = gst_dep.partial_dependency(compile_args: true, includes: true, sources: true)
+  python_ext_dep = python_dep.partial_dependency(compile_args: true)
 endif

 gstpython = python.extension_module('_gi_gst',
@@ -17,7 +19,7 @@ gstpython = python.extension_module('_gi_gst',
     install_dir : pygi_override_dir,
     install_tag: 'python-runtime',
     include_directories : [configinc],
-    dependencies : [gst_dep_for_gi, python_dep, pygobject_dep],
+    dependencies : [gst_dep_for_gi, python_ext_dep, pygobject_dep],
 )

 env = environment()