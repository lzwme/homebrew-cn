class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://ghfast.top/https://github.com/unicorn-engine/unicorn/archive/refs/tags/2.1.4.tar.gz"
  sha256 "4dc18409ccb93f1a63fbbd1c7adc9c58621c8a510fbb179d9b8c46017feb6796"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5200eb854bc9eb48fffb80907e085a0f27a40f39be6e7417c4919796b17703ba"
    sha256 cellar: :any,                 arm64_sonoma:  "bc9194fe54a2043faff3d872a28ba059ddd701e25bfc031523d6cb3c4b9f2785"
    sha256 cellar: :any,                 arm64_ventura: "b1b9b349ef440687069b196bd734b12127fc6bbbeca5534d3fe1a1ef7ed7a8bb"
    sha256 cellar: :any,                 sonoma:        "1b015937527513f6732a10e28f9bb98c2e9ba5792a138a17d54e366139fe390c"
    sha256 cellar: :any,                 ventura:       "635966ef5349c658ede76b5771ad49ed14bf2e9ad4a029ad4e485dff78b556d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8575b89de2be41a8f9333f7da916ad6fa0fedb0fc0c9724ce1f289cea541b214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0da9b580273cab0f9bbeb87fba10b3e0f8307c8df5b7e14717742a4e1911ae2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DUNICORN_SHARE=yes", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test1.c").write <<~C
      /* Adapted from https://www.unicorn-engine.org/docs/tutorial.html
       * shamelessly and without permission. This almost certainly needs
       * replacement, but for now it should be an OK placeholder
       * assertion that the libraries are intact and available.
       */

      #include <stdio.h>

      #include <unicorn/unicorn.h>

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
    system testpath/"test1"
  end
end