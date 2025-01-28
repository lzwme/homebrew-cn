class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https:github.comawslabsaws-c-common"
  url "https:github.comawslabsaws-c-commonarchiverefstagsv0.10.9.tar.gz"
  sha256 "fd3c452232972ca65f09ba9cd7657bd6e39d5386a4f4eae3f3cd344eee1b88ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5053978e40f1495670ccabe5d53fbdd0cf085a764869cf7a5ff21a8a17162bb1"
    sha256 cellar: :any,                 arm64_sonoma:  "e7d0bc748f7b4b0149ac2291199dc7d55058f168c7784b6e6aa56993d7756444"
    sha256 cellar: :any,                 arm64_ventura: "5bdc4aded5559019e49ced4988b27375a336ea0b51b4122afbb2f9e610873733"
    sha256 cellar: :any,                 sonoma:        "c0e613b5282a4d555b7c41b3c81766866ed1b82c76526b91bf59c849974c8600"
    sha256 cellar: :any,                 ventura:       "dc435a8a6ebea8a2313eea5de8b744fd67bef8b545bb5d609e2ee0427e0d3a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a561624d2eb971c19d3da99e60533ab2db2929d269c2852c1b5537fd0e0647"
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