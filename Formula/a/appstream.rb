class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://ghfast.top/https://github.com/ximion/appstream/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "2160a8d9205448214a9e3c9fe3bc205fa630542109c8bf869b26951989b9bb38"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "08f193fc41cb5622d73ebba0ca0608d490c8003d12f4db0bbbf3672854439eaa"
    sha256 arm64_sequoia: "749741d9356a04b9a64bddb25ae321841c8623b6d11da2fdf673061dd3842d5a"
    sha256 arm64_sonoma:  "02fc3d49c3c9e317533eaa2cab9f37d5744b4e72bfc5535c85f006febd527bfa"
    sha256 sonoma:        "78ea766ecf853ea1a195cd9eb0c3c2e002b40697ea272c064047dcbf8d24ae84"
    sha256 arm64_linux:   "d8ab6e547d8a1d006b3c30e420b7abdb63ddda35a616ab4f9ed5f4f802c6c454"
    sha256 x86_64_linux:  "081fa01b2d6ddc06f09b8537239247613ca1f168cfab0001518c34d1b569a288"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "libfyaml"
  depends_on "libxmlb"
  depends_on "zstd"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "gperf" => :build
    depends_on "systemd"
    depends_on "wayland"
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
      -Dbash-completion=false
      -Ddisplay-detection=auto
    ]

    args << "-Dsystemd=false" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"appdata.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <component type="desktop-application">
        <id>org.test.test-app</id>
        <name>Test App</name>
      </component>
    XML
    (testpath/"test.c").write <<~C
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
    C
    flags = shell_output("pkg-config --cflags --libs appstream").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/appstreamcli --version")
  end
end