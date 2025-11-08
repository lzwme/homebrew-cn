class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https://github.com/besser82/libxcrypt"
  url "https://ghfast.top/https://github.com/besser82/libxcrypt/releases/download/v4.5.1/libxcrypt-4.5.1.tar.xz"
  sha256 "e9b46a62397c15372935f6a75dc3929c62161f2620be7b7f57f03d69102c1a86"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c0f2054f259335f5d11e663fa3691150e269c242d2dfd8e97413758b434179d"
    sha256 cellar: :any,                 arm64_sequoia: "2232e650ddd88be1b9d70d4bebf0e2ab36001e6ae07014449fa82ba8ee8d4a32"
    sha256 cellar: :any,                 arm64_sonoma:  "bf89d130e965823653402a8446cb947d70a9c7a3abf3d88a702f12fa2518c686"
    sha256 cellar: :any,                 sonoma:        "63cfca65ae97ffcfd2df990e5e554763e35008039ea5b1bd4af464a32ae4264a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c09b64163b5f71d0618bced354d5814e599ee8eda03d62fcbc38be9a305773e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9617e096e96d3d0c684510d5c085f328a4bbb3783a41abd86da6543273f5ca9a"
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