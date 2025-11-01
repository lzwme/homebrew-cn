class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "4a2a0918c763639f18d971367df6b528a1f3a0660f1c66d5791e435e8e671db9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bd291730b249d7c0079430ce15103bcd2ff50646423182308ab7d961d5f3384"
    sha256 cellar: :any,                 arm64_sequoia: "5715489f8ba6a09337e6c98852f575811eb8add2a8ab108862a37352987118cb"
    sha256 cellar: :any,                 arm64_sonoma:  "282fa5faf7d8df4473e875f9a70184b2702ead0dacc8d39f29f06f9d4e47622c"
    sha256 cellar: :any,                 sonoma:        "3f361070564237848d31375f0ded30979bab9885ecac382c5518cddcf8fd0450"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "594a4e984ab8db651cd342ec5f4d9e8fb59c82dde839264b24a5b5f3451ed4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5739d97e912fd703eb829c931af794151db0614d1baa3bf05b3852c062c4c9"
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
    (testpath/"test.c").write <<~C
      #include <aws/cal/cal.h>
      #include <aws/cal/hash.h>
      #include <aws/common/allocator.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
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
    system "./test"
  end
end