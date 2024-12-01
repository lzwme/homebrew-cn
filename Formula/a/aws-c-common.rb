class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.10.4.tar.gz"
  sha256 "72ebf3cfe105d74af8f43ccd07d33a0ecf881dba1caa2ddeaaf1fa1c5f9794f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cf3f2b98d223f5cb1d75e08669b8d810eed8a617c38c5ba2ee57cd7ba697c49"
    sha256 cellar: :any,                 arm64_sonoma:  "e7e67a7622875a1f34235632484989ad3e01528feafb5665fe7a5c9aad992799"
    sha256 cellar: :any,                 arm64_ventura: "8e36fab6dd5ffae89c61c0640bda90b3fee5d73749fcef3833665cd9bced3742"
    sha256 cellar: :any,                 sonoma:        "664762aa7ee6a6b3ab2b8e477c64779c9974a142052a7495dcfd91a0821ffdd6"
    sha256 cellar: :any,                 ventura:       "7843f3a2a20fae123c6038c958e5f0017dfc274797cc7c5d194b58f4dc1c7951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55d6121641b116dbbf1fbb259304f524b992f7d319a06ad53f4772a023b239b"
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