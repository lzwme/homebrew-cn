class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://ghproxy.com/https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.2.tar.gz"
  sha256 "22008b4639197edfc3c5797c8bd1d7a3b2e684bf669a26834faf12b4026dba1c"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44822a5af46c82e127d26fbb09e8414d2b620aa20bf7cce163044946b4e464d5"
    sha256 cellar: :any,                 arm64_ventura:  "31e8134a0117762a06430d128324ff9ff15b1fb46cbced34bc8730a40c9630e5"
    sha256 cellar: :any,                 arm64_monterey: "db58a4e363812fb91b5bd44e0d292401e6cef1aa92347147306ef82c086bbec0"
    sha256 cellar: :any,                 sonoma:         "25d600fa1a8bf00ff41236be00c0a1712e5cfc12e4bc7213b85af5674aaf83f4"
    sha256 cellar: :any,                 ventura:        "47e0ed177e1841bbf512ed539bcd779200b5afa447b3c42f5c733b9042bd6b6a"
    sha256 cellar: :any,                 monterey:       "c8fed9baae960e1d81005cf3fc7cbb0fa81779f96b12dc7c19b7af5d03c8096b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c8c1b42541ef82e6e492c3c44f4d46773cc36f95e14b5124da8efb926fe89d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "minizip", because: "both install a `libminizip.a` library"
  conflicts_with "libtcod", "libzip", because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DMZ_FETCH_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DMZ_FETCH_LIBS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz_compat.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/minizip", "-L#{lib}", "-lminizip", "-o", "test"
    system "./test"
  end
end