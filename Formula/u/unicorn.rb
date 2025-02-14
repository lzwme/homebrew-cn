class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https:www.unicorn-engine.org"
  url "https:github.comunicorn-engineunicornarchiverefstags2.1.2.tar.gz"
  sha256 "bfc6dbff23288c4ae9eb73d8cd01099bc9caed35bf9f0c5afc951080d3ff3fa5"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https:github.comunicorn-engineunicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd7852e6ed8f9cadd2e3e50ed7da6df5d577b33c3021c56dab5a926bd006e83c"
    sha256 cellar: :any,                 arm64_sonoma:  "8ecd87d04d221d4b756056a85a69220a8184e25827aa415d800c6635baa183df"
    sha256 cellar: :any,                 arm64_ventura: "af4a69b5ee19db6723106ce8bb0166e5fdb2aba242839982bf0a76d2bf237835"
    sha256 cellar: :any,                 sonoma:        "3f91d7fc55b15557b23a8349dfc197277eb8867c897202202647ac0b3760089b"
    sha256 cellar: :any,                 ventura:       "bfaf40cef1d184648ddd53a953f8276ba37e8df7b7fda71be70f16c21cf1db5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8df2c53e1bae3995aa99a2a8414a279930ab9ec94ffecd5b6a32d1581976378"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DUNICORN_SHARE=yes", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test1.c").write <<~C
      * Adapted from https:www.unicorn-engine.orgdocstutorial.html
       * shamelessly and without permission. This almost certainly needs
       * replacement, but for now it should be an OK placeholder
       * assertion that the libraries are intact and available.
       *

      #include <stdio.h>

      #include <unicornunicorn.h>

      #define X86_CODE32 "\x41\x4a"
      #define ADDRESS 0x1000000

      int main(int argc, char *argv[]) {
        uc_engine *uc;
        uc_err err;
        int r_ecx = 0x1234;
        int r_edx = 0x7890;

        err = uc_open(UC_ARCH_X86, UC_MODE_32, &uc);
        if (err != UC_ERR_OK) {
          fprintf(stderr, "Failed on uc_open() with error %u.\\n", err);
          return -1;
        }
        uc_mem_map(uc, ADDRESS, 2 * 1024 * 1024, UC_PROT_ALL);
        if (uc_mem_write(uc, ADDRESS, X86_CODE32, sizeof(X86_CODE32) - 1)) {
          fputs("Failed to write emulation code to memory.\\n", stderr);
          return -1;
        }
        uc_reg_write(uc, UC_X86_REG_ECX, &r_ecx);
        uc_reg_write(uc, UC_X86_REG_EDX, &r_edx);
        err = uc_emu_start(uc, ADDRESS, ADDRESS + sizeof(X86_CODE32) - 1, 0, 0);
        if (err) {
          fprintf(stderr, "Failed on uc_emu_start with error %u (%s).\\n",
            err, uc_strerror(err));
          return -1;
        }
        uc_close(uc);
        puts("Emulation complete.");
        return 0;
      }
    C
    system ENV.cc, "-o", "test1", "test1.c", "-pthread", "-lpthread", "-lm", "-L#{lib}", "-lunicorn"
    system testpath"test1"
  end
end