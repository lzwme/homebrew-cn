class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.43.tar.xz"
  sha256 "c810f362c82a834ee89da81e34cd1452c99789339f46f6037f4b9e227dd06c01"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1ba79c6cd7ae62406d4d5be2e2096fa4e153eebfdf40eb21d3d0986f33b3d5d"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build

  uses_from_macos "libxslt" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_predicate man7/"xkeyboard-config.7", :exist?
    assert_equal "#{share}/X11/xkb", shell_output("pkg-config --variable=xkb_base xkeyboard-config").chomp
    assert_match "Language-Team: English",
      shell_output("strings #{share}/locale/en_GB/LC_MESSAGES/xkeyboard-config.mo")
  end
end