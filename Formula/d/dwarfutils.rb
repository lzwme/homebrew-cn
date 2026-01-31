class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.3.0.tar.xz"
  sha256 "a153e8101828a478f88d18341267b59c19a3fc794bea47388347ce994ba90c17"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "865a20a866158713e928b94fef3fd2bf925136518d03debf33b3e0e19cb7f82e"
    sha256 arm64_sequoia: "04fc7ca60516a1a025d9762ac5c01d9f25a609712be54e115fb8d38e5d407f7b"
    sha256 arm64_sonoma:  "1d09a3442b005106f20f49ad214c755acb768440e23fb4a882d326c58f522fa1"
    sha256 sonoma:        "6176b4aee6cc1d16893ff9f4b709344fa06f71c7fff66882ce1381530c2bbfef"
    sha256 arm64_linux:   "c60ffb5f4253a5d932a990a31f5fa28992b6621ef29c4b78b5f9db6fcb199d0a"
    sha256 x86_64_linux:  "6d0abb8c210f02c399cbb1350849120a460213ebdbe68ba66a020e466cdd55e9"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dwarfdump", "-V"

    (testpath/"test.c").write <<~C
      #include <dwarf.h>
      #include <libdwarf.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        const char *out = NULL;
        int res = dwarf_get_children_name(0, &out);

        if (res != DW_DLV_OK) {
          printf("Getting name failed\\n");
          return 1;
        }

        if (strcmp(out, "DW_children_no") != 0) {
          printf("Name did not match: %s\\n", out);
          return 1;
        }

        return 0;
      }
    C
    system ENV.cc, "-I#{include}/libdwarf-#{version.major}", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end