class MmCommon < Formula
  desc "Build utilities for C++ interfaces of GTK+ and GNOME packages"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/mm-common/1.0/mm-common-1.0.6.tar.xz"
  sha256 "b55c46037dbcdabc5cee3b389ea11cc3910adb68ebe883e9477847aa660862e7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93fdb7bd94d6b01caafaf53f6cb3d729f8440d7efe1246ff47d8387a81683364"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    mkdir testpath/"test"
    touch testpath/"test/a"

    system bin/"mm-common-prepare", "-c", testpath/"test/a"
    assert_predicate testpath/"test/compile-binding.am", :exist?
    assert_predicate testpath/"test/dist-changelog.am", :exist?
    assert_predicate testpath/"test/doc-reference.am", :exist?
    assert_predicate testpath/"test/generate-binding.am", :exist?
  end
end