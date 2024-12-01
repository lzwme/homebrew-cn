class AwsCSdkutils < Formula
  desc "C99 library implementing AWS SDK specific utilities"
  homepage "https:github.comawslabsaws-c-sdkutils"
  url "https:github.comawslabsaws-c-sdkutilsarchiverefstagsv0.2.1.tar.gz"
  sha256 "17bdec593f3ae8a837622ef81055db81cc2dd14b86d33b21df878a7ab918d0e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "60251edaf6dee0cb239551f720d67d1cd861e2d933669ae455f1b71bb51823c1"
    sha256 cellar: :any,                 arm64_sonoma:  "f0213650734acc76c2f62dd620fff442460687f39f820d23b12a585a8b7d4f5d"
    sha256 cellar: :any,                 arm64_ventura: "ef4af34e42bfc2a968f9a9aa3c1887a50b96e67510759b140bcd0e999a69da2a"
    sha256 cellar: :any,                 sonoma:        "5292fdf532814b7da1b48e8dda0c0c477a3f5425b8da13724ac01e7ec8fd2e59"
    sha256 cellar: :any,                 ventura:       "522967008caae2ed7ce4e5d96fd654a8cabc14638add7bd47b1ef547ec99c566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcb64399f6b6a26e5c33b0ced8a2cba6ff4d124794a4d881c313414e4082405"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-common"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmake
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~'C'
      #include <awscommonallocator.h>
      #include <awscommonstring.h>
      #include <awssdkutilsaws_profile.h>
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
    system ".test"
  end
end