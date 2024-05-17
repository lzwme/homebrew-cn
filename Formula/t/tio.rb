class Tio < Formula
  desc "Simple TTY terminal IO application"
  homepage "https:tio.github.io"
  url "https:github.comtiotioreleasesdownloadv3.3tio-3.3.tar.xz"
  sha256 "506635b2e922306be3ded980d0b6fd8bb74647b1561b01015b769041f7ddca8d"
  license "GPL-2.0-or-later"
  head "https:github.comtiotio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a6cb9dadcf9adfa3b82a712aff9695c0ea0e1f5f285b38a24dcbb22eb220c5d2"
    sha256 cellar: :any, arm64_ventura:  "87f5ba075fbb3408b70711f00a0ddd67f90ec651c63c45d11c09568889d44266"
    sha256 cellar: :any, arm64_monterey: "14404c3e7e49ffb4b08ff491f8d9b6eb6ae494402a88df87d81d35cf85dfd0c5"
    sha256 cellar: :any, sonoma:         "2f7174b84c39fd0aac91ca32a92c4bfa0078fe6929b54e4b030e41296119ed75"
    sha256 cellar: :any, ventura:        "ac54a9c0a273a2d1b0df54e59df492a14e37bcaeff516a8b350159a3fb397348"
    sha256 cellar: :any, monterey:       "b66bc3b66bc1dcf1f72e9391a71fc9a459715150d62dd2c12574eb5e4968a98c"
    sha256               x86_64_linux:   "ac7e9dff65fa25a0dea1b4f43d136a1473dff90252ebed179c1fc7ad19ce1eba"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "lua"

  def install
    system "meson", "setup", "build", "-Dbashcompletiondir=#{bash_completion}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q devnull #{bin}tio devnull", 1).strip
    else
      shell_output("script -q devnull -e -c \"#{bin}tio devnull\"", 1).strip
    end
    assert_match expected, output
  end
end