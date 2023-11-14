class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://ghproxy.com/https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "3078651f995cb6313b1041f07f4dd1bf0e9e4d394d6e2adc6e92ad0b621291fa"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3c785555791b9723a093f4681846b9b271be63cc581be12915000d87f215ade"
    sha256 cellar: :any,                 arm64_ventura:  "08cb9d62a7982f902b5649a0a4bdc29727fcd22755cfa5ca7a158689bcdea6b4"
    sha256 cellar: :any,                 arm64_monterey: "a0611767704dde1fe950f6f6417cdf30b8761d46bab42b986bc9d196aee8a8b3"
    sha256 cellar: :any,                 sonoma:         "c6fb343b596f45695e4b12a84821a2ca1df3f58cfe92450406af3b0bcf0aac53"
    sha256 cellar: :any,                 ventura:        "676cca4704faf5e1b097d48ddd9082b9023e3f373797868cec2b67cd8675503a"
    sha256 cellar: :any,                 monterey:       "3faa5299da67cad5cd0d27670e3c879d3907382766ce7edd3e96c6dbabc40955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1131214b6fbeaa578f2f47bdff7c03af9233ca70412c4ef304f744aa8b77454f"
  end

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "gettext"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_ENABLE_BMFF=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      ..
    ]

    system "cmake", "-G", "Unix Makefiles", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end