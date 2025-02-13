class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.11.1.tar.gz"
  sha256 "b442cc59f507fbe232c0ae433c836deff83330270a58fa13bf360562efda368a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f354dfc009faee192a4c3fc282ba81cbd8f9f21796d51d0a268556c30eb3c52a"
    sha256 cellar: :any,                 arm64_sonoma:  "47a29d1fe463ec759310c01c1d30afb0d2e570833d200dc89674f399173cbec6"
    sha256 cellar: :any,                 arm64_ventura: "2982547b948c5d4587766b3995aad940b5205c9347e418decf76336a7fa17eb1"
    sha256 cellar: :any,                 sonoma:        "ea3ea9b359b491ca8cf88327d4616e8b27f1c6732dbe2590e69f4723d731ecc9"
    sha256 cellar: :any,                 ventura:       "2e891329e0e55b7a0a72bc3de931a9c9298812c34700d2f06558ea60c7724d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74fc074cbb72be594de571b061be896bb1f06c6c5bebe258475d0642332fa6ac"
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