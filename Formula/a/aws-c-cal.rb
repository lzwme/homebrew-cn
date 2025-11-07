class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https://github.com/awslabs/aws-c-cal"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-cal/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "a41b389e942fadd599a6a0f692b75480d663f1e702c0301177f00f365e0c9b94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "211b8f7468ed07aaddc8dd0d4902588dadf8a77da92cd12e09227f234139ee08"
    sha256 cellar: :any,                 arm64_sequoia: "cf1743072185bd1a94f9f73831575dd6a02bdd69e962a7ded01c374ab387e8c6"
    sha256 cellar: :any,                 arm64_sonoma:  "91b92be0a63370405e6dc81baeeb3b9abcbba1135c285ec29c733733752dd05e"
    sha256 cellar: :any,                 sonoma:        "eed948f81ff8a185e8ac635af4b24f75cfe10a341a749017ce3cc7b3cbc564a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11854657fa2a94c57e4611058b85dd6265a67e19826f2525188e5dd629a561a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee5ce2ee6d63a643548c8c7fa8885defbdcb539c1bf53595376b88acdf304be"
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