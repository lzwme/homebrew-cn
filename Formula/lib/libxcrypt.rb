class Libxcrypt < Formula
  desc "Extended crypt library for descrypt, md5crypt, bcrypt, and others"
  homepage "https:github.combesser82libxcrypt"
  url "https:github.combesser82libxcryptreleasesdownloadv4.4.37libxcrypt-4.4.37.tar.xz"
  sha256 "902aa2976f959b5ebe55679b1722b8479f8f13cd4ce2ef432b0a84ae298fffd0"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbbaf4f7983c7190960cc5dbbc81946914f68b504b663d5daab61dfa1a19f482"
    sha256 cellar: :any,                 arm64_sonoma:  "3ef8b81995024e420c8d23afd17f058183cfcc3fae868d01a4db3235a4406b13"
    sha256 cellar: :any,                 arm64_ventura: "1baa9fd775d201867bade2ea0a9b8d5b9c8a9a34f732ea51e70fb78b97c3f3da"
    sha256 cellar: :any,                 sonoma:        "6a65c8955aca11b162fb4f81161512356510df5bfe7971714438e33778c23404"
    sha256 cellar: :any,                 ventura:       "a9a04fbb57a0c514381eadc50bd517caa16eba8066d50438e2171766d909f5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9302812e0c3766a187276600cbc3c1c9d44e4f4eca3bbd202d5b19cdc34dfd7"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build

  link_overwrite "includecrypt.h"
  link_overwrite "liblibcrypt.so"

  def install
    system ".configure", "--disable-static",
                          "--disable-obsolete-api",
                          "--disable-xcrypt-compat-files",
                          "--disable-failure-tokens",
                          "--disable-valgrind",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
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
        if (strcmp(hash, "$2b$05$abcdefghijklmnopqrstuuRWUgMyyCUnsDr8evYotXg5ZXVFHhzS")) {
          fprintf(stderr, "Unexpected hash output");
          return -1;
        }

        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcrypt", "-o", "test"
    system ".test"
  end
end