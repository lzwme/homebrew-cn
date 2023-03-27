class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1831",
      revision: "9f99e742df8115297cc265244f451e769a3ab23b"
  version "r1831"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfc0154bb0901adaeda48885c322b9fa9f6d46c921aa996ef62f136ca28782d8"
    sha256 cellar: :any,                 arm64_monterey: "64442bbfea388d7e93912efe19091c6f7419e360959fb1326a934e1a1f35fe13"
    sha256 cellar: :any,                 arm64_big_sur:  "bac4d6baa5855ebee547c5d30c4d87061ddd44d81f4e945c9c984ca2503fd96c"
    sha256 cellar: :any,                 ventura:        "7f85c8ac1858ac624025c4ed78f4e76da7884e46270aaa1cfc4ebfc24f984161"
    sha256 cellar: :any,                 monterey:       "5cfc66e71191a5084f0d66d8ce278190108d68f019065686ca01840cefd40e30"
    sha256 cellar: :any,                 big_sur:        "6b91045eeb72b9c7cb010ca83f45e8486f41b450b7d5725c17f074695b9ba63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aceb7486fd67b49487cd7f596a9541973586bc94b209b59b910700c4c949fe55"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end