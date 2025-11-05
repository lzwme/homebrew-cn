class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://ghfast.top/https://github.com/besser82/libxcrypt/releases/download/v4.5.0/libxcrypt-4.5.0.tar.xz"
  sha256 "825e764e4ff2e6304adb814cda297074b222d54a04edbd8ebc7cf58fc3af857d"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfa836c215867bd755934755677878aea34be10c20d83216dfe333410c3de51a"
    sha256 cellar: :any,                 arm64_sequoia: "2985b83e686111c4c4987affa262a62568c4777e9490a7d32f96b7ef8312d727"
    sha256 cellar: :any,                 arm64_sonoma:  "1cdbc6d81035a498aca3621d34c4119493aa1e7cda6f7290abc6a222986b517e"
    sha256 cellar: :any,                 sonoma:        "7cd32b92ea29fcc10e25da846bb1d3daa7ea410c11fcb49f4b736c0203b17e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9199a3ea8f7fd9184bb813549038b7205869513b082ab91df117361d97ffe0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f1f5760e115329f13fb995ebcf83033eea62ce9cb93bf0906cea8dd512ee52"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build

  link_overwrite "include/crypt.h"
  link_overwrite "lib/libcrypt.so"

  def install
    system "./configure", "--disable-static",
                          "--disable-obsolete-api",
                          "--disable-xcrypt-compat-files",
                          "--disable-failure-tokens",
                          "--disable-valgrind",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcrypt", "-o", "test"
    system "./test"
  end
end