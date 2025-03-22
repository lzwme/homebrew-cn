class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https:github.comlibfusesshfs"
  url "https:github.comlibfusesshfsarchiverefstagssshfs-3.7.3.tar.gz"
  sha256 "52a1a1e017859dfe72a550e6fef8ad4f8703ce312ae165f74b579fd7344e3a26"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    rebuild 1
    sha256 arm64_linux:  "bd70a34c078fcb7601b4c509ac54d36ac53e46118dc958c3cb75e909afcaefa8"
    sha256 x86_64_linux: "0eb28ad70ce9c608b66eed7f32169f6e5201fd68e3a4fd8a48a6194499cc82af"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin"sshfs", "--version"
  end
end