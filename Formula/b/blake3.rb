class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.6.0.tar.gz"
  sha256 "cc6839962144126bc6cc1cde89a50c3bb000b42a93d7e5295b1414d9bdf70c12"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46f2bf5364e33864bb4b03469f3467323c9d356dbcc10863a8fb169f4fe1e18e"
    sha256 cellar: :any,                 arm64_sonoma:  "827b9d7ea9bb0b90acc353699c45b55f6275f52745e1f886267cf7f77d296275"
    sha256 cellar: :any,                 arm64_ventura: "cac59fb889e1c60b03f2332f79ffef614808271f9ddea493304e55d38d96891b"
    sha256 cellar: :any,                 sonoma:        "31115852814c71c6d9c3502f9d4953684bb4da699da9ca5adfebcaefee3a2705"
    sha256 cellar: :any,                 ventura:       "2febfb3fdc8f35b53a63e13f97de29f0cc62813ceecc15ccf71edb13a8ad8baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f63d005b03ad556eb0e982b1e1802ecdc31a508e4c6a2870409fbcf4a450a223"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "c", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <errno.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <unistd.h>

      #include <blake3.h>

      int main(void) {
        blake3_hasher hasher;
        blake3_hasher_init(&hasher);

        unsigned char buf[65536];
        while (1) {
          ssize_t n = read(STDIN_FILENO, buf, sizeof(buf));
          if (n > 0) {
            blake3_hasher_update(&hasher, buf, n);
          } else if (n == 0) {
            break;  end of file
          } else {
            fprintf(stderr, "read failed: %s\\n", strerror(errno));
            exit(1);
          }
        }

        uint8_t output[BLAKE3_OUT_LEN];
        blake3_hasher_finalize(&hasher, output, BLAKE3_OUT_LEN);

        for (size_t i = 0; i < BLAKE3_OUT_LEN; i++) {
          printf("%02x", output[i]);
        }
        printf("\\n");
        return 0;
      }
    C
    (testpath"input.txt").write <<~EOS
      content
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lblake3", "-o", "test"
    output = shell_output(".test <input.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e", output.strip
  end
end