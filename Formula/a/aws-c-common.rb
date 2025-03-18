class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.12.1.tar.gz"
  sha256 "303505ed8770be88364c5fb7cac1843e5958ea1389cca8f1f0a84103d7660494"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f34a21ac368dcfe8a68f08948c96b2878fd74a45bdb30ea0afcb8e5e6af3866d"
    sha256 cellar: :any,                 arm64_sonoma:  "ee3f62db55b25db9bd9d34868b6b26a0c58ebe0e3cdf18a0742224b9ccba69c7"
    sha256 cellar: :any,                 arm64_ventura: "398d4669689fdff23c896412d76cd1775a1f55c771d6edec05b895a1b066193c"
    sha256 cellar: :any,                 sonoma:        "be95c58d2ec4b99edc75fb7ca9d51df9a883cb1bacd1bda30d148613cd79caa8"
    sha256 cellar: :any,                 ventura:       "4ebc8dba6139f9aceb47bf05fa70be256dac23c674229f564060391682c31361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1ccb676a0d032e378e0e1bc22ebed58065bca2f3e8f21a6dad0d5c057437a1"
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