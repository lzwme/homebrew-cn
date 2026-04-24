class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://ghfast.top/https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.1.1.tar.gz"
  sha256 "ecc1a514f9e455cb627a768e1219369c576a761bc04196941590906c8b622d7e"
  license "Zlib"
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f957d07757148ab8a8f611f49f27c54938f8236ba24ecd4fc0379d22df86467"
    sha256 cellar: :any,                 arm64_sequoia: "815728d8b6633406fd7822b65c37cc046f0842242bb8f34394e8789f92b68a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "4dac875a087850a514221d9149d90919b1f97c2e541cda609a0fc9c6506d8c86"
    sha256 cellar: :any,                 sonoma:        "fb1f5b34730044930ee6d3bd087be10571764f94e1259da6b0951fb2eadd0e72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673126c43bb60541bbfe0dcc99dcfce5dff44da93576b64e568a0e575d646b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "890491339ee3b557cdf5ef18bdc422aa73eec6f7d4488f30744a34491ff17015"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DMZ_FETCH_LIBS=OFF
      -DMZ_LIB_SUFFIX=-ng
      -DMZ_LIBCOMP=OFF
      -DMZ_PPMD=OFF
      -DMZ_ZLIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip-ng.a"
    (include/"minizip-ng").install "mz_config.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdint.h>
      #include <time.h>
      #include "mz_zip.h"
      #include "mz.h"
      #include "zip.h"
      int main(void)
      {
        zipFile hZip = zipOpen2_64("test.zip", APPEND_STATUS_CREATE, NULL, NULL);
        return hZip != NULL && mz_zip_close(NULL) == MZ_PARAM_ERROR ? 0 : 1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/minizip-ng", "-L#{lib}", "-lminizip-ng", "-o", "test"
    system "./test"
  end
end