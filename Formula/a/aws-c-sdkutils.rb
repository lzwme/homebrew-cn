class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "14fe900f80c3b9f5e53a783d9ac0865ed9ba1ae63b67744b9f82a8b3194a4388"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12e53ddcf6420f0109756010843908712e88c22638e200c5cbc0322b73891de9"
    sha256 cellar: :any, arm64_sequoia: "ce7275fd31e8a75be22660782c7e75237daf036788f1983625d29a49be0034df"
    sha256 cellar: :any, arm64_sonoma:  "96c5882e17e8ce44a8b2f39f4b7a94e81611dae6a7e4ca143dda5b6ea24fded0"
    sha256 cellar: :any, sonoma:        "e9b98246467a6c9870698c7f16f706a40fd9e47684beabcf157cd9516c79141e"
    sha256 cellar: :any, arm64_linux:   "5d61ac825b379449a3628ef6072510cd8b7eb8b8ce31064b02ba53525428b764"
    sha256 cellar: :any, x86_64_linux:  "ac72abc24f0664ee82f5083d8a118ebea739b9954ad02a3d97b60a6fc268fd10"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <aws/common/allocator.h>
      #include <aws/common/string.h>
      #include <aws/sdkutils/aws_profile.h>
      #include <assert.h>

      AWS_STATIC_STRING_FROM_LITERAL(s_single_simple_property_profile, "[profile foo]\nname = value");

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();

        struct aws_byte_cursor contents = aws_byte_cursor_from_string(s_single_simple_property_profile);
        struct aws_byte_buf buffer;
        AWS_ZERO_STRUCT(buffer);
        aws_byte_buf_init_copy_from_cursor(&buffer, allocator, contents);
        struct aws_profile_collection *profile_collection =
          aws_profile_collection_new_from_buffer(allocator, &buffer, AWS_PST_CONFIG);
        aws_byte_buf_clean_up(&buffer);

        assert(profile_collection != NULL);
        assert(aws_profile_collection_get_profile_count(profile_collection) == 1);

        struct aws_string *profile_name_str = aws_string_new_from_c_str(allocator, "foo");
        const struct aws_profile *profile = aws_profile_collection_get_profile(profile_collection, profile_name_str);
        aws_string_destroy(profile_name_str);
        assert(profile != NULL);

        aws_profile_collection_destroy(profile_collection);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-sdkutils",
                   "-L#{formula_opt_lib("aws-c-common")}", "-laws-c-common"
    system "./test"
  end
end