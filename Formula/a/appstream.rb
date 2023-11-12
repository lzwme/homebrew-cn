class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://ghproxy.com/https://github.com/ximion/appstream/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "95d5cf451d1945182a9bc4d597c13e713451a3dba1a5759f45b6b3279ff3774c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "13958c6501fe66eae4db052bc4b1cafdace94582dfce971246a2576f0eecdb39"
    sha256 arm64_ventura:  "e22556e5fba8e18bddde908ca3cb87fa32b1bf27a87ce636e7d64eb9c976cdbd"
    sha256 arm64_monterey: "c96f102ea8b12a4d41028ceb82792c1e22869583a038c950e0e0390d81815343"
    sha256 sonoma:         "d35f7905d588c035bd4d90075c843a409ab59934e678d6900aa580a3b18918c0"
    sha256 ventura:        "a0bc82b0bf8a07097069d9c3c67b59378624b693ef6cf5ebfd259e83c543bfa7"
    sha256 monterey:       "13c2bf0823221c19bd96ca07adcf30fb7b69bb3f30ad1f25ef2b864011fee113"
    sha256 x86_64_linux:   "b51dce98eeb7f1b48288d677ecaa2c9adaabc2ad16bde8281bc661a64c87b757"
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

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "gperf" => :build
    depends_on "systemd"
  end

  patch do
    url "https://github.com/ximion/appstream/commit/952cc682c1a39b7e5338d97f0cbee76e911d3979.patch?full_index=1"
    sha256 "b9cb967ab35ee46c6db5dcf83a41922ef1d2f60239a05ad708a4fc4014a90e06"
  end
  patch do
    url "https://github.com/ximion/appstream/commit/0ad6af8a47fa6747f5cbe9b4a7a96ea6d6def0a8.patch?full_index=1"
    sha256 "09eccfde59d35e7559c694410e1763867b2c6dd8454ffce895d1b8be235ca474"
  end
  patch do
    url "https://github.com/ximion/appstream/commit/8d752b0637960c8e31a325e09f3c2c730ee5bd86.patch?full_index=1"
    sha256 "3302241cb1c935a5b601ee490e3c0d70a1ae85ab7ad285de66598bdacaf6f7b4"
  end

  def install
    # Use GNU sed on macOS to avoid this build failure:
    # sed: RE error: illegal byte sequence
    # Reported to the upstream developer by email as a bug tracker does not exist.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    inreplace "meson.build", "/usr/include", prefix.to_s

    args = %w[
      -Dstemming=false
      -Dvapi=true
      -Dgir=true
      -Ddocs=false
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