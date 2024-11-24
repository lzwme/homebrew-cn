class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.11.2.tar.xz", using: :homebrew_curl
  sha256 "5d471308cef4c4752bbcf973d9cd37ba4cb53739116c30349d4764ba1410dfc1"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2494bafc73a82fa1b2529edfa5fcfe182b8106224667cdf04ae5421d98c4d467"
    sha256 cellar: :any,                 arm64_sonoma:  "ab4af5a2277a7fc98299be889a18b8a234025ab728415128029e50de2e3a68c9"
    sha256 cellar: :any,                 arm64_ventura: "66813828486a24c74a23ccf43775c31933cc45cf6b1dbf52ac5c3348bd20adb6"
    sha256 cellar: :any,                 sonoma:        "fdc878d65b2da686d8eb3177313766edeb70c2ddd0d25cf3f18d5d479dcdf30c"
    sha256 cellar: :any,                 ventura:       "7e6909a3b89b416f531f3e1f4bc5f0d78f346c057fade881e81cf700c8bb6fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a73f6968abe482c71683d07d069e098b4f7b4163f187eaa85fb8f956877dbd"
  end

  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "libtcod", because: "libtcod and libzip install a `zip.h` header"

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