class Polkit < Formula
  desc "Toolkit for defining and handling authorizations"
  homepage "https:github.compolkit-orgpolkit"
  url "https:github.compolkit-orgpolkitarchiverefstags125.tar.gz"
  sha256 "ea5cd6e6e2afa6bad938ee770bf0c2cd9317910f37956faeba2869adcf3747d1"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "812f69589b874c7617c40900b75cc00724f442f009a6537d2185b30b7e8fa141"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "duktape"
  depends_on "expat"
  depends_on "glib"
  depends_on :linux # macOS requires some patches to build due to installing into usrlib
  depends_on "linux-pam"
  depends_on "systemd"

  def install
    args = ["-Dsystemdsystemunitdir=#{lib}systemdsystem"]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
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
    EOS

    flags = shell_output("pkg-config --cflags --libs polkit-gobject-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end