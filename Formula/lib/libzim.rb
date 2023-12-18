class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https:github.comopenzimlibzim"
  url "https:github.comopenzimlibzimarchiverefstags9.0.0.tar.gz"
  sha256 "681f0419d421be05ffd14dbab65c42103ebffb86deceed70b8bd6f9b0590ecd6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "05556b0dd7e15025d7f0ee32b9a77e974ee03970a5ba2eedb1a976be1cf568b8"
    sha256 cellar: :any, arm64_ventura:  "7384f32beed27dd8b60109003d61ac6b355380784f73c4a56232c5f7fccc2acd"
    sha256 cellar: :any, arm64_monterey: "7f87d54a0c70c681527780059f59be67864f09c7d3652ef83227117a78462e9c"
    sha256 cellar: :any, sonoma:         "11157004064b95c8af93dff1ccafbeda934c4cb6c55020a3f9810d81fde4a166"
    sha256 cellar: :any, ventura:        "80455360ada79773869ca22b4860d8fc6252ed0487fa24d8908ae9c5ef30b3f0"
    sha256 cellar: :any, monterey:       "f2061b18ad748166d32a3e101f3e52df2bfd86647fe7b4e3fb8da77e255943e1"
    sha256               x86_64_linux:   "3a3e0b3464b95a4bfdee53add4abebed77501629cf68d85a90a63730461e1ca7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "icu4c"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <zimversion.h>
      int main(void) {
        zim::printVersions();  first line should print "libzim <version>"
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"

    # Assert the first line of output contains "libzim <version>"
    assert_match "libzim #{version}", shell_output(".test")
  end
end