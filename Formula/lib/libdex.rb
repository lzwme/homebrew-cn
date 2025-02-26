class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.9.1/libdex-0.9.1.tar.gz"
  sha256 "8106d034bd34fd3dd2160f9ac1c594e4291aa54a258c5c84cca7a7260fce2fe1"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "de849fbc65398cd3211401ec52da982cb0de056560f41b3e2160d1feb7a73439"
    sha256 cellar: :any, arm64_sonoma:  "29dfd7bc1929d344f4c3f6f494cadc6128dda0878a1aadfc36c7c3c176c6341d"
    sha256 cellar: :any, arm64_ventura: "5be369e6134c47622e5b011578440873938ef02d947367ae7fa0bf39a6dd4f71"
    sha256 cellar: :any, sonoma:        "2febc85628e62c50dde34a00489a9305c4e5685a5dccbef795be377ef4f546e3"
    sha256 cellar: :any, ventura:       "7a42ee50ef5afa0d4708c3004bca40f4fd6457dda4c5665497842d2995822280"
    sha256               x86_64_linux:  "8452e353f07907069edccfd963920c8545673aa759047e0b1a9e253b226c57f5"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build # for vapigen
  depends_on "glib"

  # Guards a libatomic check that fails on macOS
  # Upstream ref: https://gitlab.gnome.org/GNOME/libdex/-/merge_requests/21
  patch do
    url "https://gitlab.gnome.org/GNOME/libdex/-/commit/24e6bddd32c7db70235bb1576c33731a26609ffb.diff"
    sha256 "f7b0e4b92cd1a3cebfb1a62f5ffd74b7d77f550be74627311c3a29e8ad991cd4"
  end

  def install
    args = %w[
      -Dexamples=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples", "build/config.h"
  end

  test do
    cp %w[examples/cp.c config.h].map { |file| pkgshare/file }, "."

    ENV.append_to_cflags "-I."
    ENV.append_to_cflags shell_output("pkgconf --cflags libdex-1").chomp
    ENV.append "LDFLAGS", shell_output("pkgconf --libs-only-L libdex-1").chomp
    ENV.append "LDLIBS", shell_output("pkgconf --libs-only-l libdex-1").chomp

    system "make", "cp"

    text = Random.rand.to_s
    (testpath/"test").write text
    system "./cp", "test", "not-test"
    assert_equal text, (testpath/"not-test").read
  end
end