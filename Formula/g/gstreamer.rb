class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https:gstreamer.freedesktop.org"
  license all_of: ["LGPL-2.0-or-later", "LGPL-2.1-or-later", "MIT"]

  stable do
    url "https:gitlab.freedesktop.orggstreamergstreamer-archive1.22.9gstreamer-1.22.9.tar.gz"
    sha256 "68782dc3e0c1ab5963a53e7199084c982bb0bd1d297164c4c660117fa1b27f64"

    # When updating this resource, use the tag that matches the GStreamer version.
    resource "rs" do
      url "https:gitlab.freedesktop.orggstreamergst-plugins-rs-archivegstreamer-1.22.9gst-plugins-rs-gstreamer-1.22.9.tar.gz"
      sha256 "e64d21a5178a7dab63aaaf965f47f4493e06eec4bd5d18982a9f652bc7bedd91"
    end
  end

  livecheck do
    url "https:gstreamer.freedesktop.orgsrcgstreamer"
    regex(href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "59d79a79490f426c49794bc979ac91d0488cb777d462de05666d5dd2b525aad7"
    sha256 arm64_ventura:  "472a254e6490c6f4cc4fe8e3338ca6ca051466006b8fdc84a23581504156a559"
    sha256 arm64_monterey: "4251feab47bea30f6e72cc8466358243f98e3103d0a906a58c293598e5bf591c"
    sha256 sonoma:         "4d75f60f15653f0c7dda131d560dfe63f327cf9b8356fb4ee484c1875731f714"
    sha256 ventura:        "295a551def422add1cf92512e2f4b49dec279e146cbb1adb55c09b6aae18bbfa"
    sha256 monterey:       "bd4c1f748d4e9143c9ce56c6df01918e1a58363735c80efac54951fe5bcb90ea"
    sha256 x86_64_linux:   "2af40bc79fc7a0aeaf0e8af90c9baea5308121c76e7b557e5998ffcef70004d4"
  end

  head do
    url "https:gitlab.freedesktop.orggstreamergstreamer.git", branch: "main"

    resource "rs" do
      url "https:gitlab.freedesktop.orggstreamergst-plugins-rs.git", branch: "main"
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
    (buildpath"subprojectsgst-plugins-rs").install resource("rs")

    # Add support for newer `dav1d`.
    # TODO: Remove once support for 1.3 API is available in release.
    # Ref: https:gitlab.freedesktop.orggstreamergst-plugins-rs-merge_requests1393
    inreplace "subprojectsgst-plugins-rsvideodav1dCargo.toml", ^dav1d = "0\.9"$, 'dav1d = "0.10"'

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
    args << "-Dbuild-tools-source=system" if build.head? # make unconditional in 1.24+
    inreplace "meson.build", "subproject('macos-bison-binary')", ""
    odie "`macos-bison-binary` workaround should be removed!" if build.stable? && version >= "1.24"

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
    assert_equal version, resource("rs").version,
                 "The `rs` resource should use the tag matching the `gstreamer` version!"

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
index 5977ee3..1b399af 100644
--- asubprojectsgst-pythongioverridesmeson.build
+++ bsubprojectsgst-pythongioverridesmeson.build
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