class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "da518accb60eb08e0d56f641f00c3ea856c36a0972394770c978e5ff3bfc3728"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4db06153e44a5be76ab3f36c808d120fa8ab2ceec7c9288bbc5039a2b2777227"
    sha256 cellar: :any, arm64_sequoia: "ef6c01060db87c301b7f6870c4f91d05d0a093dc8b1a1bef0ad790b85cb2dc79"
    sha256 cellar: :any, arm64_sonoma:  "47cafac0c29101fc40fdbf7f8fddbde460970157805ab7f69175775e192a3e23"
    sha256 cellar: :any, sonoma:        "76a3fcf0e2d179ee7dabc087366f44ce01c00d89fcb7f712b24245f4c4932c7d"
    sha256 cellar: :any, arm64_linux:   "eac67e364ddb534ca1bede1be23b978c0c5846400f4f1bcfd63892ccee8cc189"
    sha256 cellar: :any, x86_64_linux:  "eb4f2bc7bd3ef1de7e698212b54ef24f045b9be6c910caa154f20ee49829bde2"
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