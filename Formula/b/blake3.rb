class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://ghfast.top/https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.6.tar.gz"
  sha256 "da7b5b0b6cf7106fe54b7d718d1ea371cce434cd15ebe5e56ca011b645cbef0e"
  license any_of: ["CC0-1.0", "Apache-2.0"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aacaacb4120d923cc1f9bb97fa5799bf9affca92137a7d7b8d2b0ccc1d3cabed"
    sha256 cellar: :any, arm64_sequoia: "8de54a00699e6a7013ba6cdf557b7cb648267e01f40c51b0aa7a7f235917f1f7"
    sha256 cellar: :any, arm64_sonoma:  "c1f6ea49dc2a5bee553d6ed7a855db736338e5417c10bad3c31d0d4616b78c6e"
    sha256 cellar: :any, sonoma:        "8ad070d8dad70749b897a11c5e40dc43d532dab9f45df8255b97b9983a48a55f"
    sha256 cellar: :any, arm64_linux:   "4c7c810236ba6ee6a6dbaecdd37c01896691e7c07ec2c99e59fe4bc2f3713f20"
    sha256 cellar: :any, x86_64_linux:  "0af81b5ee00e74aa3d1ed15b60bc1fd0e531bd32d18cb0cf4005ad6b67498d62"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "c", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
            break; // end of file
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
    (testpath/"input.txt").write <<~EOS
      content
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lblake3", "-o", "test"
    output = shell_output("./test <input.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e", output.strip
  end
end