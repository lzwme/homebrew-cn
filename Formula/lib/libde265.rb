class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://ghfast.top/https://github.com/strukturag/libde265/releases/download/v1.1.2/libde265-1.1.2.tar.gz"
  sha256 "eaacd1943ab0c452c19f6136a36ca227e6b761b39a81eaca8454d48c147e1f67"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "81969bb0b887c9d54c448c2c662565fcde2e81ba22576abd1c49b516f85f2d82"
    sha256 cellar: :any, arm64_tahoe:       "8f8d8510112ab8b4ddabd02816d262cf9bc3387d0f713348a2ed961f4250547f"
    sha256 cellar: :any, arm64_sequoia:     "5ce0fa549a0462e69b9254266fb8859a271a991416d72bdcfb80e622beba77be"
    sha256 cellar: :any, arm64_sonoma:      "2518ecf2bd8479445010ce181f3a66565f760256411ea911f80cea4085687280"
    sha256 cellar: :any, arm64_linux:       "b59b9b9c60c31374d8ec851e7c8960cb51694801b348af200b7bc1bef24e8257"
    sha256 cellar: :any, x86_64_linux:      "d31f63ce2a21ac52eb377bcf39e89be3c3204f21a4d04cafb872a3b8e4d28120"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}",
                    "-DENABLE_DECODER=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <libde265/de265.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        de265_decoder_context *ctx;
        const char *version = de265_get_version();

        if (strcmp(version, LIBDE265_VERSION) != 0) {
          return 1;
        }

        if (de265_init() != DE265_OK) {
          return 2;
        }

        ctx = de265_new_decoder();
        if (ctx == NULL) {
          de265_free();
          return 3;
        }

        printf("%s\n", version);

        de265_free_decoder(ctx);
        de265_free();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lde265", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end