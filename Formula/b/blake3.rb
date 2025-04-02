class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.8.0.tar.gz"
  sha256 "b9f565adc6e2c8c813dafd6d5406a71382f7ac6aa3250b19e9d8a68c457fd769"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6754edf57ac7a94d12b861c7ada9ca51c3583f5c5b76193adfa3b828125f186c"
    sha256 cellar: :any,                 arm64_sonoma:  "4d82531d981cea8a4c445eeea0e968df27563b8180d47b9114c85c146e4349be"
    sha256 cellar: :any,                 arm64_ventura: "a107d79771fbd3a46b04870266609489cc97d879a674c39f75c453db20cea811"
    sha256 cellar: :any,                 sonoma:        "4c48308f775eff3158b7b6520b1bc64b5b345b9e0ea2507505f4c3e2a6f94594"
    sha256 cellar: :any,                 ventura:       "dcd7d0aa1f14edb079d80fe27d4fd20807c512633bb10947a04bcad4c452054c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1664f1c727adafcbc0737a4574e9934dd7cf194d43bb9b408db55e4f7696d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba2bd7e76f5eb8ef6cac6c77347388c0f2b8b411d42405ded229bae5236810b"
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