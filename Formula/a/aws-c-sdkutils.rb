class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https://github.com/awslabs/aws-c-sdkutils"
  url "https://ghfast.top/https://github.com/awslabs/aws-c-sdkutils/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "13a03ea87aa67c7db414bf245fbcc623555c783a34d8ba1d7d701fd42717c366"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c72db8f20cfb94e0d771c20c916362d4597693e1c5e97a5482fd190470c6e88d"
    sha256 cellar: :any, arm64_sequoia: "6c4e4fbceeefeb1a55a9ccb9e5bad341ca5f661a65c1ebe8709c68193cf853e6"
    sha256 cellar: :any, arm64_sonoma:  "720f35bcb3c50215a3eb99194f91b7e645e77d23939f569924751d6b66022501"
    sha256 cellar: :any, sonoma:        "9debf7f306ba663508e030e8e75aee0d81b8cbeae24c0133bb762d00fa9f2272"
    sha256 cellar: :any, arm64_linux:   "c3e52291f52b019bcd8a9f8081110501b76128203a54e1bb2f546deb9013f0be"
    sha256 cellar: :any, x86_64_linux:  "446a2499a0723015330032c5766f6a0069c823db4426dc05dcf178e2627ee264"
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
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end