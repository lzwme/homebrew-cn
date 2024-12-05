class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.10.5.tar.gz"
  sha256 "368e4e9aa5fc31144bd93487c22d856684f9638c8a06b74b08946d0adf7a7dd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e563375aade72bd5c6208ad9106e8657c3a441bc2edd37ad00a5e638786a0455"
    sha256 cellar: :any,                 arm64_sonoma:  "e7cb7783bbc3e381a6f97e36330311dddb82132f63e9c0ff6262e2875ebb3919"
    sha256 cellar: :any,                 arm64_ventura: "f05c8b4ca167d21e23157d1a75d62218de8be1afc1c0c89c1ab7519b5a95138a"
    sha256 cellar: :any,                 sonoma:        "62334fce071beea0fd3299f3b396b15e7564606577637b2727811a5975b59842"
    sha256 cellar: :any,                 ventura:       "7fdbcfb4b0442ccd5a983ff0f666dc9e1cc566d5243aaac11b08b7673c262661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cdc02c6c33020c5ea1323570cc6bb8cbb659478d9aa1adfcd146015c38532da"
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