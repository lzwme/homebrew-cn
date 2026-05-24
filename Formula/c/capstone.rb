class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://ghfast.top/https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.8.tar.gz"
  sha256 "467e128736227a12a2066c562cfe69a2b7c45353fab3f02a0522d9cd62ccf0f6"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "923bcd14ef518df04f6ecb6ee5cebbe98445c88b62b07e8ed36cc63b3ecd1ddc"
    sha256 cellar: :any,                 arm64_sequoia: "6bc2f05c4fd271659382e4e2439704a0d62442b1d15e498798c5b94de9def463"
    sha256 cellar: :any,                 arm64_sonoma:  "efba0ec954702daa9b6e601b21150de9f4933ef26d86ee95d3c803dc6825dcff"
    sha256 cellar: :any,                 sonoma:        "6ebde69977e1a62f611f49f1d4f2b7dfe090fd64e2a18e43602f508b4b71ac2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e70412696fc099abb8a2fc20cc57ec49cf8c2bc44a317e0cd419a44f8ec0a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe908ade334d04a6dbc2b0581ed54f230bdaa164a9f042694ddffdf7fc7ba475"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["HOMEBREW_CAPSTONE"] = "1"
    ENV["PREFIX"] = prefix
    system "./make.sh"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # code comes from https://www.capstone-engine.org/lang_c.html
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <inttypes.h>
      #include <capstone/capstone.h>
      #define CODE "\\x55\\x48\\x8b\\x05\\xb8\\x13\\x00\\x00"

      int main()
      {
        csh handle;
        cs_insn *insn;
        size_t count;
        if (cs_open(CS_ARCH_X86, CS_MODE_64, &handle) != CS_ERR_OK)
          return -1;
        count = cs_disasm(handle, CODE, sizeof(CODE)-1, 0x1000, 0, &insn);
        if (count > 0) {
          size_t j;
          for (j = 0; j < count; j++) {
            printf("0x%"PRIx64":\\t%s\\t\\t%s\\n", insn[j].address, insn[j].mnemonic,insn[j].op_str);
          }
          cs_free(insn, count);
        } else
          printf("ERROR: Failed to disassemble given code!\\n");
        cs_close(&handle);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcapstone", "-o", "test"
    system "./test"
  end
end