class AwsCCal < Formula
  desc "AWS Crypto Abstraction Layer"
  homepage "https:github.comawslabsaws-c-cal"
  url "https:github.comawslabsaws-c-calarchiverefstagsv0.8.6.tar.gz"
  sha256 "a2075819d26692c6c494854161b8d44a768ec65d3d8941ce450f91d6c0d01795"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3477e91fbf22380e45493e6ebc82ddf55f17a286a8ec65d56945f6423a0bccaa"
    sha256 cellar: :any,                 arm64_sonoma:  "3701ca2ac6ed676c2f7a53280364f98a74049964a517e492a9cbdcfe3d746e4b"
    sha256 cellar: :any,                 arm64_ventura: "69e04abebcf210b44e0c8a94ea675eeaf34cb186d26b52b46c61bcd8cfe1099b"
    sha256 cellar: :any,                 sonoma:        "e390844cb5555629f4fa1eea0e9bcf45b25447acdf864d13b3fcd58ffdbdf824"
    sha256 cellar: :any,                 ventura:       "b51884043c847c5dc3512d03f55024d1424536fdf41de75a19dc44e8262a6231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4fc8ec2355c4ecf5d7abc47963f16aaca00e01b6343461020e550ebcf0714e"
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