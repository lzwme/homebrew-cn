class Appstream < Formula
  desc "Tools and libraries to work with AppStream metadata"
  homepage "https://www.freedesktop.org/wiki/Distributions/AppStream/"
  url "https://ghproxy.com/https://github.com/ximion/appstream/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "4470a27474dc3cc4938552fbf0394b6a65d8a2055d4f4418df086d65d8f2ba29"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "58dfde567bb5c7f5b0062d4a975ff00dd89ec0bd99d011251f863dbf6b153edc"
    sha256 arm64_ventura:  "470f0e5fab4267324ca772134083082ecf9aadeb8077249c3e8a3d194c887c60"
    sha256 arm64_monterey: "13829ac0b94e1fd725bcd93bf5ea457c4f03f0e303af5dbdfa4d0faa4477ac16"
    sha256 sonoma:         "244cdeb62533ad303829285bbc3fb29a98e1892d6b5bd05de60bae144370fa0d"
    sha256 ventura:        "cc92f24966387c88d7cb77bb8767431989d23d90e0a525c86e2f9fb5626fbd22"
    sha256 monterey:       "513afece09af3b5801bb2e33b18f8622d9a45174557614540e1f6fa61536a3a0"
    sha256 x86_64_linux:   "fa33486228fde054d1c4de2df52ee6ec88231d771fd46e3f4f2e20be5166af0f"
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