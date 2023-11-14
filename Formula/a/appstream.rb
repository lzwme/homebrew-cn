class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://ghproxy.com/https://github.com/ximion/appstream/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e964fea8b4b7efac7976dc13da856421ddec4299acb5012a7c059f03eabcbeae"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "fea3ceef7de44039d1f6903b7553d3f27bbaf6c5264749d88426370e71f9cfc2"
    sha256 arm64_ventura:  "122be0f2b9287feaf5a99ccd6c10fdff5ee7057aeb192af8b2f7dcbf7eb078a7"
    sha256 arm64_monterey: "d2af4844cac58077a37a4c2c15f6efcb4a0f6bc7a4f0d3d0f393315a0bba7ae6"
    sha256 sonoma:         "d52e13dad503fb2d3ee49ac19aa53644316f156630fd68816f90dd2220fe0999"
    sha256 ventura:        "ad9c30d09234316c029d84c5c6d6e9f261749248592fe789d82c8dad23527897"
    sha256 monterey:       "07aa33e27ab6644baee01d70312b8b1a56eb69b7cec589546cc3468bdf44c76c"
    sha256 x86_64_linux:   "995bec05eb79d642334dccd3534815c4b8ef64b277dc5de1bfbe564ce99b17fe"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "libxmlb"
  depends_on "libyaml"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "gettext" => :build
    depends_on "gperf" => :build
    depends_on "systemd"
  end

  # fix macos build, upstream PR ref, https://github.com/ximion/appstream/pull/556
  patch do
    url "https://github.com/ximion/appstream/commit/06eeffe7eba5c4e82a1dd548e100c6fe4f71b413.patch?full_index=1"
    sha256 "d0ad5853d451eb073fc64bd3e9e58e81182f4142220e0f413794752cda235d28"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    inreplace "meson.build", "/usr/include", prefix.to_s

    args = %w[
      -Dstemming=false
      -Dvapi=true
      -Dgir=true
      -Ddocs=false
      -Dapidocs=false
      -Dinstall-docs=false
    ]

    args << "-Dsystemd=false" if OS.mac?
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"appdata.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <component type="desktop-application">
        <id>org.test.test-app</id>
        <name>Test App</name>
      </component>
    EOS
    (testpath/"test.c").write <<~EOS
      #include "appstream.h"

      int main(int argc, char *argv[]) {
        GFile *appdata_file;
        char *appdata_uri;
        AsMetadata *metadata;
        GError *error = NULL;
        char *resource_path = "#{testpath}/appdata.xml";
        appdata_file = g_file_new_for_path (resource_path);
        metadata = as_metadata_new ();
        if (!as_metadata_parse_file (metadata, appdata_file, AS_FORMAT_KIND_UNKNOWN, &error)) {
          g_error ("Could not parse metadata file: %s", error->message);
          g_clear_error (&error);
        }
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs appstream").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/appstreamcli --version")
  end
end