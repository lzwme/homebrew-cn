class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https:github.comawslabsaws-c-io"
  url "https:github.comawslabsaws-c-ioarchiverefstagsv0.17.0.tar.gz"
  sha256 "edf8dbd19704685f7400c6fc3fcb875ab858b1e55382c7ec933efddff28b2332"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ac54844fc128c359d78e50dd477f888a50eea0351aac85b9aaaa7e2ee6d42fc"
    sha256 cellar: :any,                 arm64_sonoma:  "d941617b9154f510dcde32419ee171a0f4d4c4b773a7268b4270881de44b0d32"
    sha256 cellar: :any,                 arm64_ventura: "a443297894ef1ee54ec6a1184cd3f1b16a488b0e86affa5d81dfec23285d8b24"
    sha256 cellar: :any,                 sonoma:        "0f0d63c304a855744e9a7b4f8260b705c108162f00a2a147b804ef540dbd8e91"
    sha256 cellar: :any,                 ventura:       "403da3e379f7fb4cb93073218d992360b2ad7c1f3bac7039a9e2037668a51ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2083e8c39c21c5f7abc25111f02bb042e6f42e728c6055c77c9f39e8a91792"
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