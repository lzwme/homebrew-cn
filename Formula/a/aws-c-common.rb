class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "f47dea1686742098db2ae5a9f7296af4fc8d27494dc80e03e4fa2fe802fa86ab"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3868debee6ec72728fde31f95587ea9db683c66fd9d8a6c14fb3170514d93340"
    sha256 cellar: :any, arm64_sequoia: "e3ea3b069e31fb709da8706cfb6fafa47840aa815c2dbe2162ff90bd23644ec4"
    sha256 cellar: :any, arm64_sonoma:  "7a068529e6ca5ffa476becdbe0f747085545f5307528aad5bbd2075bc08a2ff8"
    sha256 cellar: :any, sonoma:        "1df417b6da14c1faf98336a030a2d31ba24a516442b7db22b2cd3c16c2140048"
    sha256 cellar: :any, arm64_linux:   "77c3098fbe911ec55f7d5aa62abbb03e90143a371b233ddbdab80f6ddb35682c"
    sha256 cellar: :any, x86_64_linux:  "a8866cddd9efb84204287574f66d9162504289eed3c7b58eb81b9f07ed377b54"
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