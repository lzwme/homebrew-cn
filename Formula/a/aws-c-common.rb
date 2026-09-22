class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-common/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "634b782369f4c52bdd5878d0c2ab5ddeff707daaf2f087d6dd063ed92651d2c9"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4d3d6713b4e3df7b8f6cb9e9b27f5e09d42c7ee683ec434e9e3d6a08bd7e2a25"
    sha256 cellar: :any, arm64_tahoe:       "4c65ece9be5e0b9e69500fc019fc459796a1c426f5e968c550e0c17e6d3db9b8"
    sha256 cellar: :any, arm64_sequoia:     "86dcc6bfad74a0228ccad573d23c3e9295ace83c909979578c666950e587a81a"
    sha256 cellar: :any, arm64_linux:       "8e6934f564a9a0d6ddf65dcc8807cc82f8189ee035f6efd2a738a3ade17077b7"
    sha256 cellar: :any, x86_64_linux:      "203b6c3a31b202901940f78ec9f9ef48e7eca0a7139520a9da36c279ded0e057"
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