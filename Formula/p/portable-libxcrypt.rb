require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableLibxcrypt < PortableFormula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://ghfast.top/https://github.com/besser82/libxcrypt/releases/download/v4.5.0/libxcrypt-4.5.0.tar.xz"
  sha256 "825e764e4ff2e6304adb814cda297074b222d54a04edbd8ebc7cf58fc3af857d"
  license "LGPL-2.1-or-later"

  livecheck do
    formula "libxcrypt"
  end

  def install
    system "./configure", *portable_configure_args,
                          *std_configure_args,
                          "--enable-static",
                          "--disable-shared",
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