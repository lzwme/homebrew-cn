class Gom < Formula
  desc "GObject wrapper around SQLite"
  homepage "https://wiki.gnome.org/Projects/Gom"
  url "https://download.gnome.org/sources/gom/0.5/gom-0.5.4.tar.xz"
  sha256 "57ba806fe080a937d5664178d21bad7653b2c561ea128187a7b10bc1762b7f65"
  license "LGPL-2.1-or-later"

  # We use a common regex because gom doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "72a2093c242c6de92ce26583e6add094f4ca79cc9d71e6232f8ee04a6024b2c7"
    sha256 cellar: :any, arm64_sequoia: "73a0c35e97b516467216c1d954c15e54c13659846143c7b76bfa5f99a7fecdc0"
    sha256 cellar: :any, arm64_sonoma:  "92d91eced46a0e8176cb2b99b064f908f283901373b2aedcfc64d94a782fc7e7"
    sha256 cellar: :any, sonoma:        "68a3c7f359dbfae00c68786ae064a84a42fd306005bfcf527eadaa948fec9275"
    sha256               arm64_linux:   "c633b0b89815e1c525338d1ca8a9be3fe5a53e7cb917b3e2c3886a5257eff5d7"
    sha256               x86_64_linux:  "72438d9c9681d46a624474e9e6dddd5eb7d7aaf2a907b8a9b5e87d36c6eab43b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "sqlite" # indirect dependency via glib

  def install
    site_packages = prefix/Language::Python.site_packages("python3.14")

    system "meson", "setup", "build", "-Dpygobject-override-dir=#{site_packages}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gom/gom.h>

      int main(int argc, char *argv[]) {
        GType type = gom_error_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gom-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end