class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.6.1.tar.gz"
  sha256 "1f2fbd93790694f1ad66eef26e23c42260a1916927184d78d8395ff1a512d285"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30d327d236551e0f5d44b748ccc1ffa1708cec2f873e8e744004176466c73efd"
    sha256 cellar: :any,                 arm64_sonoma:  "ca77e185ee72b22d95d77fa4a0414339bfbb15166ab59a9c53149ea6e4cce7be"
    sha256 cellar: :any,                 arm64_ventura: "484317c04a4d68713e9f9c2e2a059fe4a9a54001b31c5f4f4ee8482a35696c7d"
    sha256 cellar: :any,                 sonoma:        "6cbabfe00f67dc7bb20ed2234d52694798615d46b077cef3eba220e21794cc69"
    sha256 cellar: :any,                 ventura:       "b352b089146d718d8f912ef05d237f29e2dd5f1b10d4457067aa7cc9b4e37218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c642c53051c3aca9e8e87f68c934102128183570add1b35911eaa467411cb3e"
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