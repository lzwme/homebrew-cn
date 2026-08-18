class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://ghfast.top/https://github.com/knik0/faac/archive/refs/tags/faac-2.0.tar.gz"
  sha256 "70bf59db35b2d129c6fe204200427950405d0a63bea3ff8fa8804648dde2cbce"
  license "LGPL-2.1-or-later"
  compatibility_version 2
  head "https://github.com/knik0/faac.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f72fd900a15e5310d843aff5ba4d7009eb998e4c96dbaad0022c18b374e2f15"
    sha256 cellar: :any, arm64_sequoia: "72dedc080426673a99cbafaa8e14fb47c7bf645324440e1e1ab2d428bd4b5337"
    sha256 cellar: :any, arm64_sonoma:  "aa218ab06b72dd58fa88c8f2666d1e411f89939f9864488a1710f8c565875df9"
    sha256 cellar: :any, sonoma:        "b922c6c7f6bc80a974ed0fdebf18146e97c317d9beb592563ed0844bd0a729e1"
    sha256 cellar: :any, arm64_linux:   "d3f934d44cdd70b84f8f40a3f7902ba4a171e0855955414deccb71440fdd1b98"
    sha256 cellar: :any, x86_64_linux:  "d119019ee23f1a01e622ba7e4761e645e46a810281318d402fb9e01cefda016d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_path_exists testpath/"test.m4a"
  end
end