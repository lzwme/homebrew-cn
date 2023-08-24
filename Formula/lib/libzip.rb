class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.10.1.tar.xz", using: :homebrew_curl
  sha256 "6d9ad40d2f9cd204c9e28c8a406e46289c0e887533c5174f4a38cf504fe1870e"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c7ad6f3d539228628f0ccafd7bd17cc57dc6c49021dd162a9414fcdd01160240"
    sha256 cellar: :any,                 arm64_monterey: "3511bb753f885c7107e6969065d04a26a2c1daa35aea702d918d92a145df227a"
    sha256 cellar: :any,                 arm64_big_sur:  "d5de82dd71926d71671e6d60c2ab471dc96aece2205fd991b7ad3ae396c7ffa8"
    sha256 cellar: :any,                 ventura:        "b5243e86143979663899b53bea2468c33c2dd7a497af084e42311446715a7863"
    sha256 cellar: :any,                 monterey:       "7ca407427007d96a3f2920d9b476a39c687b42827e57be8e98d7cd1da7aaefed"
    sha256 cellar: :any,                 big_sur:        "abc497fb00cf2e73e552ed0d29a0d05a8b1f44f3f37a240d81f809803cfa5cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104ff0ed39185eb3a1606909a977a7f78d446d4c716608fe635732648a0cdff8"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "libtcod", "minizip-ng",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    crypto_args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
    ]
    crypto_args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.
    system "cmake", ".", *std_cmake_args,
                         *crypto_args,
                         "-DBUILD_REGRESS=OFF",
                         "-DBUILD_EXAMPLES=OFF"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end