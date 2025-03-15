class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https:github.comawslabsaws-c-cal"
  url "https:github.comawslabsaws-c-calarchiverefstagsv0.8.7.tar.gz"
  sha256 "5882096093f6f39d9442f9b8a4e377155a6846277d4277334a58cd36b736674f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb8c1cab113a7976ed13d8959fe5834ea067f587959daecfaec25f6914eba77f"
    sha256 cellar: :any,                 arm64_sonoma:  "1b8e9de01c13d0271bdcec5bb07b0417f5eb664489c176fb1465b53020a1a48f"
    sha256 cellar: :any,                 arm64_ventura: "4be3fafff6ce4c03cb0d80cd5ed9e75744fb025c2a7345de58696e815f4af54f"
    sha256 cellar: :any,                 sonoma:        "eafcaf351e67cd6136ba73a831e07fd4524c7eaf3f9c5d3c2c6b2e0bc693d9db"
    sha256 cellar: :any,                 ventura:       "7e0e864280327cd4fe386472d3b8c297fd79debfa17cf7ff0980355b16f1011a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01b02a517c15f14020d60a2d6b860b89aca5a60d1c1315334496683ba25ec0a0"
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