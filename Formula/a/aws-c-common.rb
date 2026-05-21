class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "a85bfd3a9939cc9a18dcd0cbd34c66ffbefec9b908c4b4dad2217b17e21b26ff"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4d3851f2a5fd8ec2ee6baf88e87c77af439a6bcdcb19c696a956add8263eac7"
    sha256 cellar: :any,                 arm64_sequoia: "015ba350a90ff639d63a8d13d3c464bcc9dd125f8a3340b589aa5013b788200b"
    sha256 cellar: :any,                 arm64_sonoma:  "337c998d9fac22b8863e38c15e7a3095d12180602a330fe8ff9ae1440703d058"
    sha256 cellar: :any,                 sonoma:        "1d14412fc4a1f768eed63e597d615e7fffb492b230e45c995398cd300ac35dac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ed63b3b847cd7ad041b6235ae4c85283fe4f822d4b3fffef88a4875aa0383f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acaef04e208ff292c82d0c2643f6de54916cebac716199d3838904665ffca6e9"
  end

  depends_on "cmake" => :build

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