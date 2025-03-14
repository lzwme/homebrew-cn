class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.12.0.tar.gz"
  sha256 "765ca1be2be9b62a63646cb1f967f2aa781071f7780fdb5bbc7e9acfea0a1f35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c2119322d96cc9b029c2a3cd5ad2f8ae1413e6e5c9e68d495d8c20b9a8490a02"
    sha256 cellar: :any,                 arm64_sonoma:  "fed28efb1747d3bbda699485cbbc6b3ecb6ddb7c5ef7ad2c800449bf9681ee0f"
    sha256 cellar: :any,                 arm64_ventura: "bde7e8a497a7b5be3bde9a6d9c3c93140d13114e28bc407d41c0386d33f4bd89"
    sha256 cellar: :any,                 sonoma:        "39a0170d26b7d39c1b48e077b9837c365ea47c76d8923f0c0773bc21698c4eb2"
    sha256 cellar: :any,                 ventura:       "d29f91244ca788a0000ec01dc115a44ae5cef248d331f8a154e860b17bb950e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4dac69fb52c8003e7bd58458df770d12052a052c5c64de9f41a2dab532ce622"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <awscommonuuid.h>
      #include <awscommonbyte_buf.h>
      #include <awscommonerror.h>
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
    system ".test"
  end
end