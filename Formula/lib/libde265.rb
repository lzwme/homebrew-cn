class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://ghfast.top/https://github.com/strukturag/libde265/releases/download/v1.1.0/libde265-1.1.0.tar.gz"
  sha256 "afc19dd28e2fc523de5952bba5224ee1d28e286c72436d2843df126cca1181fd"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "838b17ede87dbff3a4e589fcb2e109560ebbb9f1cc5ef08ff865ab43be8f1811"
    sha256 cellar: :any,                 arm64_sequoia: "f76f4efc10002384fbec0bd610d0b6673bff1d0c0b0ca3d81a7727c2128e0991"
    sha256 cellar: :any,                 arm64_sonoma:  "c4876e8006bfd433e800b79774fbf87eba9844753cc65cf52c916aedf31cd578"
    sha256 cellar: :any,                 sonoma:        "78a4c657c1d140fedb0701514399393b581a9cfd42d2db1a032d882a06302cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e8c04ec0e2854f60f7b5be2c83a2cecb479d8475cd1fa45fb9a80196393afc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2eec369a5bc5e55bc39ec2c44b7fe45e8a95ba09716b65d3b76c0045dcdd8cc"
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