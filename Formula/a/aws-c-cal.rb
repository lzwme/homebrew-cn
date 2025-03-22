class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https:github.comawslabsaws-c-cal"
  url "https:github.comawslabsaws-c-calarchiverefstagsv0.8.8.tar.gz"
  sha256 "45a5e5e4b9070b02c8a847ff7531068f882622a4e8ac4fed4776b7729f018ea9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df3069ebdcb42ce1f2b0fe6b46dd5107313e2b2cb4c9465b210e33942bb16431"
    sha256 cellar: :any,                 arm64_sonoma:  "207d89453a2682c41f0bf4a15912757739a2b403dd1fabf9c33bfe7253aa4af5"
    sha256 cellar: :any,                 arm64_ventura: "658464bfdca0b1e824008be19553dcef30efea71e22718ee602367afc2412949"
    sha256 cellar: :any,                 sonoma:        "b746e0e8136595f4bc54c50cc47d879be957578f0c8598a6ff91a7bc4eb678ed"
    sha256 cellar: :any,                 ventura:       "e2097015d6571549e49875c7bd7dd88d96da9b86030cc1e58bf0d14a9785a5ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70ddf04849e2c09c3702888403a18a3997028454d6a3370254a6a96d0b2c6e72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7723a053acfc6e6891145d66a5baca1b7c1d4985708dce17762535026dbd860"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON"]
    args << "-DUSE_OPENSSL=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <awscalcal.h>
      #include <awscalhash.h>
      #include <awscommonallocator.h>
      #include <awscommonbyte_buf.h>
      #include <awscommonerror.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_cal_library_init(allocator);

        struct aws_hash *hash = aws_sha256_new(allocator);
        assert(NULL != hash);
        struct aws_byte_cursor input = aws_byte_cursor_from_c_str("a");

        for (size_t i = 0; i < 1000000; ++i) {
          assert(AWS_OP_SUCCESS == aws_hash_update(hash, &input));
        }

        uint8_t output[AWS_SHA256_LEN] = {0};
        struct aws_byte_buf output_buf = aws_byte_buf_from_array(output, sizeof(output));
        output_buf.len = 0;
        assert(AWS_OP_SUCCESS == aws_hash_finalize(hash, &output_buf, 0));

        uint8_t expected[] = {
          0xcd, 0xc7, 0x6e, 0x5c, 0x99, 0x14, 0xfb, 0x92, 0x81, 0xa1, 0xc7, 0xe2, 0x84, 0xd7, 0x3e, 0x67,
          0xf1, 0x80, 0x9a, 0x48, 0xa4, 0x97, 0x20, 0x0e, 0x04, 0x6d, 0x39, 0xcc, 0xc7, 0x11, 0x2c, 0xd0,
        };
        struct aws_byte_cursor expected_buf = aws_byte_cursor_from_array(expected, sizeof(expected));
        assert(expected_buf.len == output_buf.len);
        for (size_t i = 0; i < expected_buf.len; ++i) {
          assert(expected_buf.ptr[i] == output_buf.buffer[i]);
        }

        aws_hash_destroy(hash);
        aws_cal_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-cal",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system ".test"
  end
end