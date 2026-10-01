class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-common/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c33e573c6a1d758fa358a878044227139c425b46bb214d49b2c773072cab5089"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a57198d38b364731e1d96648103591531b1b23c99bc676647e698a8fc8a4c74d"
    sha256 cellar: :any, arm64_tahoe:       "4973f0fb0585c5492e0d7146cda4bb104201ac8c6ac1dd67ecc44d82cdbd71ae"
    sha256 cellar: :any, arm64_sequoia:     "0e5094e8ab7988eb54a761f4ad2bfeafac73e98c2cc4a4fe6ebf33e960aec611"
    sha256 cellar: :any, arm64_linux:       "e79a10a8921d72c5128a8563aea06d5f2f86ef635971ef00ccc5edd9629ceb39"
    sha256 cellar: :any, x86_64_linux:      "e7c81382bd4ef1846169028333f2d6c6e1c3b20251066fdba1f11142bfc008a2"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/uuid.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_uuid uuid;
        assert(AWS_OP_SUCCESS == aws_uuid_init(&uuid));

        uint8_t uuid_array[AWS_UUID_STR_LEN] = {0};
        struct aws_byte_buf uuid_buf = aws_byte_buf_from_array(uuid_array, sizeof(uuid_array));
        uuid_buf.len = 0;

        assert(AWS_OP_SUCCESS == aws_uuid_to_str(&uuid, &uuid_buf));
        uint8_t zerod_buf[AWS_UUID_STR_LEN] = {0};
        assert(AWS_UUID_STR_LEN - 1 == uuid_buf.len);
        assert(0 != memcmp(zerod_buf, uuid_array, sizeof(uuid_array)));

        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-common"
    system "./test"
  end
end