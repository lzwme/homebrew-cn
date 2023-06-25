class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.10.0.tar.xz", using: :homebrew_curl
  sha256 "cd2a7ac9f1fb5bfa6218272d9929955dc7237515bba6e14b5ad0e1d1e2212b43"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "066c19b172a2055265032312cf55dddf125a36167b62028411e95dc8fea8406d"
    sha256 cellar: :any,                 arm64_monterey: "988ec0216eb614dfe920eee413615fb94f7c3923261dec80d6abf4791b665570"
    sha256 cellar: :any,                 arm64_big_sur:  "6612a5d72171745b608623f15eb636e4f8d40c96d912c2b329bb8688354be43c"
    sha256 cellar: :any,                 ventura:        "de5581393d50b837a94ff04eb53e46a942743ea0a48487cf0a3671f587183784"
    sha256 cellar: :any,                 monterey:       "c40f0f03bf1bc98d8d8a000c2f141336130e78df5228c13cd3d3c93be9d592d8"
    sha256 cellar: :any,                 big_sur:        "4fd6eadc8424400e1e879fd62c9be67bacbaad848481776dd8775c86055a85e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f624b8f57d1b7784acc7cae66cc8afa8ad2d33f3da32c78b24b96930c7eff625"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
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