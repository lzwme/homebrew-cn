class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://ghproxy.com/https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.3.tar.gz"
  sha256 "e39a736d4f55c22fa548e68225b2e92bc22aedd9ab90d002b0c5851e3a7bdace"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11cf06fb7cf626623fccd14895c77419ca3c49bd41c73f90af97b4658d314823"
    sha256 cellar: :any,                 arm64_ventura:  "6082dcb77e2573668bde89b79b83530c4ae82ae0e5a16deb6825c18a6ed1a0a7"
    sha256 cellar: :any,                 arm64_monterey: "ea618ed1e79bd42e2c53d0f75da64bcebd7fda178dd91e340b3a44e0ddb9fade"
    sha256 cellar: :any,                 sonoma:         "c3b97595f714ff9d39b5f2cc4a62202ae3a574f6ade4114fd0b7157fd57aa99c"
    sha256 cellar: :any,                 ventura:        "8bc18abc2e1dec5c534f67c611fd8a9e588b009ae0b390855444d9e2542c6f26"
    sha256 cellar: :any,                 monterey:       "7e12b710fc48d02b951bf02854b88ec4e1edabe1d86addba72f7ba3ccebadbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7059109d7b8f382dcd36ac6c895c63e5d86156e0b7c872b372233fc2090651"
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