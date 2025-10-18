class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "d7d38eb6a63ea8ba0f301d0ad6a80094032d488e9e6c525b35236d20a9ae3ef2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f87a3a1802cf7fe786cef30be7bac22e961d2733fcaf3c321ceb0878b903d6e"
    sha256 cellar: :any,                 arm64_sequoia: "6e4279cef58092ba7d95c6f805b77ca4a8e3420010b0093d17d5ce058b749fd7"
    sha256 cellar: :any,                 arm64_sonoma:  "2f45a6fac8e5fd39da045c223883b3b6769681bfe92b272974961cdea66b2671"
    sha256 cellar: :any,                 sonoma:        "e96c9c19aec1a062f4ca16287b202c734ab499ba95671b0b8c3f48dc1fc2ecfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0af71abc4c5fac6858c2d90143017ae403fac3042d0f13f361e98722a09acd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da3fb02a60829f7092e28aa28484cde97daa1759b166403ed57fae4ca7f4b69"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end