class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://ghfast.top/https://github.com/strukturag/libde265/releases/download/v1.0.19/libde265-1.0.19.tar.gz"
  sha256 "bb19a0b485d2643e0eeb7e91f3ab32d1ad617e7c487dbedc91214ca3dbd8d7eb"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e378aa4d15d3ed8b5a55940617f7106b85706b558519c9274b99b55139cf94b6"
    sha256 cellar: :any,                 arm64_sequoia: "821492d9461be9803d700846f58e9c2fc376b7a7e4069ea8f2cc3b3512f7ba57"
    sha256 cellar: :any,                 arm64_sonoma:  "285207ab9e7ab7ec05155def2d61e4725d78f559261e50f66e35c70397528f54"
    sha256 cellar: :any,                 sonoma:        "e4e812bef14a6fc64d1cb28d2466a0a6e87f993f24fae4c0e41cd08c5e285308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4797186be12f7ab555ad927194a90fd67e2b1b8d991ae39affcfc83dee68f434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b701add8c58b44e9218a1d3411b3c67bd6b68a23b16bbc2f008f806d2280e1"
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