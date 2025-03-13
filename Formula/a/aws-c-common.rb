class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.11.3.tar.gz"
  sha256 "efcd2fb20f3149752fed87fa7901e933f3b1a64dfa4ac989f869ded87891bb3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49347bfe6cc82d3ce950822cb635d193be94ca59890d0b43502ecc9dca1ec310"
    sha256 cellar: :any,                 arm64_sonoma:  "81f8e489c6ae507c77ae4dfc67a9c48b9ad1030e8dbdfae4c1e1d31bf836cc72"
    sha256 cellar: :any,                 arm64_ventura: "201b983894a65ba0493cd0bc453952e2a357db4bdb3cfe759adbb716bcb973af"
    sha256 cellar: :any,                 sonoma:        "ea8992c7e36afa50870329e599d0ff91b26bf120abe8c36fe67493aff8c3ef2b"
    sha256 cellar: :any,                 ventura:       "056523fe7fdc62bf7a0b25d8753adedb70597f0d4effffde48ca1b6081734806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d37556dc42342a0528acc4192c4769f9d32951cb7d57fcd14044316ffdc1574"
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