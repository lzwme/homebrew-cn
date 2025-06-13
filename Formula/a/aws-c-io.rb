class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https:github.comawslabsaws-c-io"
  url "https:github.comawslabsaws-c-ioarchiverefstagsv0.20.0.tar.gz"
  sha256 "d25f5a4f2c454d258293a73d8b693376a3a340bcc2ebe0284ada01d4de3ae172"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "31032183de503bbab651bde6d16bbca254d58155912c861c49d192c62e7dea21"
    sha256 cellar: :any,                 arm64_sonoma:  "b912d57779b566a14d77e4aa84f363c284e7aa85e111582831b0cd001d92097f"
    sha256 cellar: :any,                 arm64_ventura: "3ac4f0c13652094b6bc1b4c2820e9bc14b008f00d283362424c3c0e5a85061c8"
    sha256 cellar: :any,                 sonoma:        "624882f66a181720481584980be9be7ce51e9eec1979b581735efe3ff6aff575"
    sha256 cellar: :any,                 ventura:       "1f5faeb258be41bec29488b85501c52cb88ef0518f59a2637843943c49c9aa1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a75f11259a2dd197b6adbf9f241137254a3b0a7fdb022f394666e14d4f32acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a92a39e7781f90b911772a00c5d1b923d3f6b82780f505ca5d261c55525b9812"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"

  on_linux do
    depends_on "s2n"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <awsioio.h>
      #include <awsioretry_strategy.h>
      #include <awscommonallocator.h>
      #include <awscommonerror.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_io_library_init(allocator);

        struct aws_retry_strategy *retry_strategy = aws_retry_strategy_new_no_retry(allocator, NULL);
        assert(NULL != retry_strategy);

        int rv = aws_retry_strategy_acquire_retry_token(retry_strategy, NULL, NULL, NULL, 0);
        assert(rv == AWS_OP_ERR);
        assert(aws_last_error() == AWS_IO_RETRY_PERMISSION_DENIED);

        aws_retry_strategy_release(retry_strategy);
        aws_io_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-io",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system ".test"
  end
end