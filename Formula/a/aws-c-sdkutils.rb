class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "2af9e783869ae6ebf97e91043e9783a92778adcebebd45f9769519162113913c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bba1ddee1b4316daadf50be85a7cb1657908a7338ff191445c9f70bd9050ee14"
    sha256 cellar: :any, arm64_sequoia: "bd7385bd0dfd4a50c4ae680cd4e9df5a3f92bafd3c698dc3c8a1da684372c08e"
    sha256 cellar: :any, arm64_sonoma:  "63499d9534c62844f3841d8e57a94ea500438bbfa5acf7521b38ab45458f5969"
    sha256 cellar: :any, sonoma:        "b0c01e0e267c8527c6e668531b74599743a7ac79c6600f8c31171e922e974ed8"
    sha256 cellar: :any, arm64_linux:   "1de7d2d9ec8a8057c6e8563433c800d59cf22ca9ff72db601868def192fff938"
    sha256 cellar: :any, x86_64_linux:  "53f714bef1eb1908b72267f465c6ec2b80648d9aaa4d663ee7250b903d89c609"
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