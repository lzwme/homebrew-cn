class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https:musikcube.com"
  url "https:github.comclangenmusikcubearchiverefstags3.0.3.tar.gz"
  sha256 "329c57719969cc4490d5173a926f6d4d71b1b650fe2d66431bbc9c782e0c6313"
  license "BSD-3-Clause"
  head "https:github.comclangenmusikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "f7ab780618f3e8e5789e22595bd98e675b184563c3606fd4b10ca8e6b415ff6e"
    sha256 arm64_ventura:  "a40a9d19243f725ab0dc70a38c2a18e6ba41d6e29d1a67e638e1c70350555198"
    sha256 arm64_monterey: "1fb6b52e17785b8113e00566a10cb5fc24ca31e3a0923515d16f46a50612d341"
    sha256 sonoma:         "724b02f3e7bbc3881f354663720e0ecce7704e91499e67272cb7704f3f079f30"
    sha256 ventura:        "18c67a098c10b0454c4c7da33c520d05fb534bb5afdbc588fa6374236a78683c"
    sha256 monterey:       "74265f00bcc11d2e701609ea5a92e4a5fe2432c0b36ee421f3d20bd9ea19ee87"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on :macos
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "taglib"
  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"musikcubed", "--start"
    system "sleep", "5"
    assert_path_exists "tmpmusikcubed.lock"
    system "sleep", "5"
    system bin"musikcubed", "--stop"
  end
end