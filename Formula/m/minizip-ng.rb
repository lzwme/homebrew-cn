class MinizipNg < Formula
  desc "Zip file manipulation library with minizip 1.x compatibility layer"
  homepage "https://github.com/zlib-ng/minizip-ng"
  url "https://ghproxy.com/https://github.com/zlib-ng/minizip-ng/archive/refs/tags/4.0.3.tar.gz"
  sha256 "e39a736d4f55c22fa548e68225b2e92bc22aedd9ab90d002b0c5851e3a7bdace"
  license "Zlib"
  revision 1
  head "https://github.com/zlib-ng/minizip-ng.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea68a12a79402cb2482c122ab769b964bcb44667fe2c0f1bcd5cb2bf0bee2d69"
    sha256 cellar: :any,                 arm64_ventura:  "eec66f06e26d77a8d3dd57bc26677e25aeb9a79216a39e3bdd88cd279f7d187f"
    sha256 cellar: :any,                 arm64_monterey: "c68930ccf771fbfdb3167f324d2c01ab3714bd69de4d1cf74be1deeedcd1b34c"
    sha256 cellar: :any,                 sonoma:         "673e8aef209cdf5b35091de70b04c67d37a94fc9024503f463058b438bed9d46"
    sha256 cellar: :any,                 ventura:        "15e3bd2b91b617722970e5b62ac9cc9a292ecc8c974c0022c8220fca25bc6e74"
    sha256 cellar: :any,                 monterey:       "5ae61b61ccf64ccb26700022a3ef2f2bf134152623c81ae76a0a47cb7fda9e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0038016885277010620bcbbe0a5254135c3a221ca2b73bcab9dfe49afb1050c5"
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

  def install
    args = %w[
      -DMZ_FETCH_LIBS=OFF
      -DMZ_LIB_SUFFIX=-ng
      -DMZ_LIBCOMP=OFF
      -DMZ_ZLIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libminizip-ng.a"
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

    system ENV.cc, "test.c", "-I#{include}/minizip-ng", "-L#{lib}", "-lminizip-ng", "-o", "test"
    system "./test"
  end
end