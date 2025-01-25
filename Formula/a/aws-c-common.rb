class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.10.8.tar.gz"
  sha256 "fb7ce3cf22aac2c70a7676cd8ceeea785bb6ee2e4fea7d6cfb225a12fdc62775"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a16da00958f8690a50ed4dd4f7c7f2bc06fd97c1c76db1049f6b26e83eefacc"
    sha256 cellar: :any,                 arm64_sonoma:  "437f7ca2d97ecfd86aaacd6458448b5c345df60de90ebca705ff52ded88fbc00"
    sha256 cellar: :any,                 arm64_ventura: "03fd338d6698b3acd0b942dd90412226750c23412bbe5694253f38d19eb9fb26"
    sha256 cellar: :any,                 sonoma:        "c9dc4bd9c528e2b3e22b8ac9bcb7095f347503ae6da448f66b4fcb76305e6a6e"
    sha256 cellar: :any,                 ventura:       "76df1583252af2e971e5d2fdf5799f300d5f922119abc8b3bf7039fd8b402fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536c84ff4c24d39b6fcc4889c49f2970618a9e020e2adc01edd4513b863bd77f"
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