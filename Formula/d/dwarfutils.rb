class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https:www.prevanders.netdwarf.html"
  url "https:www.prevanders.netlibdwarf-0.10.1.tar.xz"
  sha256 "b511a2dc78b98786064889deaa2c1bc48a0c70115c187900dd838474ded1cc19"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "a329fde2091ae943d9c99e7e9e393161880fb888aef9310e4e9be57b0ba504c6"
    sha256 arm64_ventura:  "f19c4376e1bc9d7626abbfc943c4cce8fb44b22ca7c23ea07984bae95d68cc3d"
    sha256 arm64_monterey: "b286ba523e02514847fd23c56adc006647a07c5dce8a8691e94789ce12b9f0d3"
    sha256 sonoma:         "24c467c4bf84198109193cb348b9125bebbffd805e1f576b8974ec9ec5931f16"
    sha256 ventura:        "eb08d6464a4c181ccc4907ce0ad709ddacaf811328d5f8b222d96b04cd4c635d"
    sha256 monterey:       "1a40ee8d9927eeea2d851b0ae86c086ce51fee697cbf64c5708173de25216397"
    sha256 x86_64_linux:   "2ad160214adb3226b48fc9a8f08c4fa8c991f835495bff0a3f78b604c711b024"
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