class Uvwasi < Formula
  desc "WASI syscall API built atop libuv"
  homepage "https://github.com/nodejs/uvwasi"
  url "https://ghfast.top/https://github.com/nodejs/uvwasi/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "5cf32f166c493f41c0de7f3fd578d0be1b692c81c54f0c68889e62240fe9ab60"
  license "MIT"
  head "https://github.com/nodejs/uvwasi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e9bc1d223efb41a0bee91c928bf2d85a57179c0ab37713dfd6941f046f3f50e9"
    sha256 cellar: :any,                 arm64_sonoma:  "957553fa84683816e9e111fcfeb9ef2199b2d0fc26cdccc4e9927e5e7aa84aab"
    sha256 cellar: :any,                 arm64_ventura: "28edfaafaf6fa3cea2414466622439a65d5d4ab98ddb4610ee3b16c62d25d65a"
    sha256 cellar: :any,                 sonoma:        "075cf1c7a4ded621c47d59adaee755993f7aeb5bc282b42dcffcf7478fdb66bd"
    sha256 cellar: :any,                 ventura:       "688985b4bedff51f9f0f26a94a694ea2cfe9b88c932e1ef3ae741e92ff1b835a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75425694689a0cbb61f9132e10f647f503eaa2a5370017dbe58f24ff5ab33b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af054bb833db53e6ee07eed754630fcd7c24abcd088a8fe15b8c9f76a9c6065"
  end

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
    # `-fvisibility=hidden` makes the shared library pretty useless.
    # https://github.com/nodejs/uvwasi/issues/231
    inreplace "CMakeLists.txt", "-fvisibility=hidden", ""
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Adapted from "Example Usage" in README.
    (testpath/"test-uvwasi.c").write <<~C
      #include <stdlib.h>
      #include <string.h>
      #include "uv.h"
      #include "uvwasi/uvwasi.h"

      int main(void) {
        uvwasi_t uvwasi;
        uvwasi_options_t init_options;
        uvwasi_errno_t err;

        memset(&init_options, 0, sizeof(init_options));

        /* Setup the initialization options. */
        init_options.in = 0;
        init_options.out = 1;
        init_options.err = 2;
        init_options.fd_table_size = 4;

        init_options.argc = 1;
        init_options.argv = calloc(init_options.argc, sizeof(char*));
        init_options.argv[0] = strdup("test-uvwasi");

        init_options.envp = calloc(1, sizeof(char*));
        init_options.envp[0] = NULL;

        init_options.preopenc = 1;
        init_options.preopens = calloc(1, sizeof(uvwasi_preopen_t));
        init_options.preopens[0].mapped_path = strdup("/sandbox");
        init_options.preopens[0].real_path = strdup("/tmp");

        init_options.allocator = NULL;

        /* Initialize the sandbox. */
        err = uvwasi_init(&uvwasi, &init_options);

        if (err != UVWASI_ESUCCESS) {
          fprintf(stderr, "uvwasi_init() failed: %d\\n", err);
          return 1;
        }

        /* Clean up resources. */
        uvwasi_destroy(&uvwasi);
        return 0;
      }
    C

    ENV.append_to_cflags "-I#{include} -I#{Formula["libuv"].opt_include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-luvwasi"

    system "make", "test-uvwasi"
    system "./test-uvwasi"
  end
end