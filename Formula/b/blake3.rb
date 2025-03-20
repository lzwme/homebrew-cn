class Blake3 < Formula
  desc "C implementation of the BLAKE3 cryptographic hash function"
  homepage "https:github.comBLAKE3-teamBLAKE3"
  url "https:github.comBLAKE3-teamBLAKE3archiverefstags1.7.0.tar.gz"
  sha256 "59bb6f42ecf1bd136b40eaffe40232fc76488b03954ef25cb588404b8d66a7e0"
  license any_of: ["CC0-1.0", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca8530fbf5d567840978be46bc79ac6785b8afc76ca7f85c334c955899c5b4df"
    sha256 cellar: :any,                 arm64_sonoma:  "46daa8ac5192643fdf561f0d7b1ae4638db382a1c9fa9595c94bbb1e66fec231"
    sha256 cellar: :any,                 arm64_ventura: "307c1b8cd50a6d785b2fd0a3077062afa3d1911e2d3e4e5a7506a1846388a2ef"
    sha256 cellar: :any,                 sonoma:        "fc1bb7f40a27e2f6f0773d645f595854a6742d9c3e05f7bf9aea44282c1e7a41"
    sha256 cellar: :any,                 ventura:       "fd6eb2e84a42713f32d1ee86fd0571b904dbef11730f50d1d85ff1073981503b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18828ddb9b96c6d8c579caa59cb068e121d83256f7187a6a905980409f8c7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8db865f0ad29f90a9d99dc84f31edacc113f99742df8a85d29dd53d62b57eac"
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