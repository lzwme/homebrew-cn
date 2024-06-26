class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https:www.prevanders.netdwarf.html"
  url "https:www.prevanders.netlibdwarf-0.10.0.tar.xz"
  sha256 "17b7143c4b3e5949d1578c43e8f1e2abd9f1a47e725e6600fe7ac4833a93bb77"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "4805ebb93da7ee975f998bcc39e0df549f099494f029f10c0fb6f1b34927b003"
    sha256 arm64_ventura:  "99073e58655a64e0612a02a277825a97bc21b3797cedef42bd0256b9d1188258"
    sha256 arm64_monterey: "8fe1ae0143c2a327d422a94b8a9035631a33df14ad3ac7e8e68ad375462c2775"
    sha256 sonoma:         "43cf44617906183e5f1287940ffefe8b8d539972f535e1e6c1566ec3cae5107a"
    sha256 ventura:        "7f61e9a57439d6f4008b534ff7ee10aedd7fa9dc167d3455b3cfbd1bc02d2ecb"
    sha256 monterey:       "7b2452b43e2541a9e7ac11db5cdd6d18d3a4804af995c2e3b809a829efeb40d6"
    sha256 x86_64_linux:   "ea1aab89ba7b7ed381080c261c45796969184cf6f08c07f5a87d318852c69106"
  end

  head do
    url "https:github.comdavea42libdwarf-code.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "sh", "autogen.sh" if build.head?
    system ".configure", *std_configure_args, "--enable-shared"
    system "make", "install"
  end

  test do
    system bin"dwarfdump", "-V"

    (testpath"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-I#{include}libdwarf-0", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system ".test"
  end
end