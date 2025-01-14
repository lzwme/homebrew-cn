class Polkit < Formula
  desc "Toolkit for defining and handling authorizations"
  homepage "https:github.compolkit-orgpolkit"
  url "https:github.compolkit-orgpolkitarchiverefstags126.tar.gz"
  sha256 "2814a7281989f6baa9e57bd33bbc5e148827e2721ccef22aaf28ab2b376068e8"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "e77b3e8f31c45b34937b1f89ca6f18cad5f6aa814c81058342f0c3cc3f32d09d"
    sha256 arm64_sonoma:  "8f04ff2a66b7a0e8ca8b4901c729a9843b864fedc3e6f4ffc078db9b1ebcb87c"
    sha256 arm64_ventura: "ce6a75f52c04e97238e06d43eb9bdbd03120f6c9f136428c5f8020949cbb19f6"
    sha256 sonoma:        "50e70a9c6929ecf3a3a0dbef0687e33ee600a8200047056d5f3bded135decd89"
    sha256 ventura:       "87c115ceb02aa6acde393d7be4d3467ab7b06b501c01964d03d4d755a17c5ef0"
    sha256 x86_64_linux:  "8c76a6ddd098a13e90a1d0026ea96b7f3ed329587425297b36719b523424b9e1"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "duktape"
  depends_on "glib"
  uses_from_macos "expat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "systemd"
  end

  def install
    inreplace "meson.build" do |s|
      s.gsub!("sysusers_dir = 'usrlibsysusers.d'", "sysusers_dir = '#{etc}sysusers.d'")
      s.gsub!("tmpfiles_dir = 'usrlibtmpfiles.d'", "tmpfiles_dir = '#{etc}tmpfiles.d'")
    end

    args = [
      "-Dsystemdsystemunitdir=#{lib}systemdsystem",
      "-Dpam_prefix=#{etc}pam.d",
      "-Dpam_module_dir=#{lib}pam",
    ]
    args << "-Dsession_tracking=ConsoleKit" if OS.mac?

    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <glib.h>
      #include <polkitpolkit.h>

      int main() {
        PolkitUnixGroup *group = POLKIT_UNIX_GROUP(polkit_unix_group_new(0));
        g_assert(group);

        gint group_gid = polkit_unix_group_get_gid(group);
        g_assert_cmpint(group_gid, ==, 0);

        g_object_unref(group);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs polkit-gobject-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end