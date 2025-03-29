class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https:github.comawslabsaws-c-io"
  url "https:github.comawslabsaws-c-ioarchiverefstagsv0.18.0.tar.gz"
  sha256 "c65a9f059dfe3208dbc92b7fc11f6d846d15e1a14cd0dabf98041ce9627cadda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b185656f7cda8240a7fe7da76bc5c3e4f45a5544cea78b944b5851d8278dd7e7"
    sha256 cellar: :any,                 arm64_sonoma:  "f4ade9b4e6614d6dc83963f157ba628149835140c652db235b3f75bc7f46e34f"
    sha256 cellar: :any,                 arm64_ventura: "3abab4bc46012054cf1b567b232325026f924dae9d5f0ebb6963698e4efaeb33"
    sha256 cellar: :any,                 sonoma:        "fb71df71aebe0894e202a8128432b2eb7ca3dcb2411c58b8f70398b431867709"
    sha256 cellar: :any,                 ventura:       "7505c664bce7dabe29a1c9b438cee8651a2fcb123f3d177ff2a95d7a84f3dcfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08acf1aace61cd2e6f6506f3e019a774680e830a4d9503fc0d0a25977ad7e297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a379f4b909e91aabc78701dbbacc05e3fb0218594884f2ee7438d414e088d750"
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