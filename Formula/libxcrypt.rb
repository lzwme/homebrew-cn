class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://ghproxy.com/https://github.com/besser82/libxcrypt/releases/download/v4.4.34/libxcrypt-4.4.34.tar.xz"
  sha256 "bb3f467af21c48046ce662186eb2ddf078ca775c441fdf1c3628448a3833a230"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d76cdfeeea22f3b5406a736ff80dd45c5347272c44f9b75414d2cd084235a171"
    sha256 cellar: :any,                 arm64_monterey: "8d32334811e28a2e7f8147d461b2b2162fbe80cbb6bd394aca37d2d02b562269"
    sha256 cellar: :any,                 arm64_big_sur:  "7407467f9246850f90576c3929d16066c3a3a0c5e3ee608ffb81b66c958ba188"
    sha256 cellar: :any,                 ventura:        "fba4389558f745eff736da05440bdeead8d7ec5b0e5d4f60ac4972636e63863f"
    sha256 cellar: :any,                 monterey:       "ab63de6d916e35f6df299a8e4b9e8cba489e2542f969459fc64373a005bf5a88"
    sha256 cellar: :any,                 big_sur:        "8bfe6b78bb0c628fdad32b892215791117d12c1d63dd8f6cc6b5da98111d093a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9a4c9593de081eaffde57136f3116140f11994174ee0f48b9cbb2a81ad59cf"
  end

  keg_only :provided_by_macos

  link_overwrite "include/crypt.h"
  link_overwrite "lib/libcrypt.so"

  def install
    system "./configure", *std_configure_args,
                          "--disable-static",
                          "--disable-obsolete-api",
                          "--disable-xcrypt-compat-files",
                          "--disable-failure-tokens",
                          "--disable-valgrind"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <crypt.h>
      #include <errno.h>
      #include <stdio.h>
      #include <string.h>

      int main()
      {
        char *hash = crypt("abc", "$2b$05$abcdefghijklmnopqrstuu");

        if (errno) {
          fprintf(stderr, "Received error: %s", strerror(errno));
          return errno;
        }
        if (hash == NULL) {
          fprintf(stderr, "Hash is NULL");
          return -1;
        }
        if (strcmp(hash, "$2b$05$abcdefghijklmnopqrstuuRWUgMyyCUnsDr8evYotXg5ZXVF/HhzS")) {
          fprintf(stderr, "Unexpected hash output");
          return -1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcrypt", "-o", "test"
    system "./test"
  end
end