class Uvwasi < Formula
  desc "WASI syscall API built atop libuv"
  homepage "https://github.com/nodejs/uvwasi"
  license "MIT"
  head "https://github.com/nodejs/uvwasi.git", branch: "main"

  # TODO: Remove `stable` block when patch is no longer needed.
  stable do
    url "https://ghfast.top/https://github.com/nodejs/uvwasi/archive/refs/tags/v0.0.22.tar.gz"
    sha256 "255b5d4b961ab73ac00d10909cd2a431670fc708004421f07267e8d6ef8a1bc8"

    # Ensure all symbols required by Node are exported.
    # https://github.com/nodejs/uvwasi/pull/311
    patch do
      url "https://github.com/nodejs/uvwasi/commit/7803a3183b4ed3ab975311eeb014365e56a85950.patch?full_index=1"
      sha256 "736e47f765c63316bb99af6599219780822d1ba708a96bfe9ae1176ad2ca6c43"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "0e3092289f2097b20a62893123dd9aa2bf5a41d1cc525394648c62d57df2fbe5"
    sha256 cellar: :any,                 arm64_sonoma:  "e571f34d903851533a284fbb5e5ed7cfc459b93d58b63c0c0f0af6449bfede9c"
    sha256 cellar: :any,                 arm64_ventura: "a17e40393f81fa0bf392923d922199567a34b1b07dd1a7184da54e241ddf0edb"
    sha256 cellar: :any,                 sonoma:        "0d535568557aeaa842fb26c0a2311ba8435fcd75c2f9375e6be7546ff2b35d69"
    sha256 cellar: :any,                 ventura:       "32d31a06edac199f59f3e483ae14b681dbbda701632b4884566c16a42be848eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f2832cdb777a9b8cb48c831df3d8943d66b140965c4894533aac0b54d2826e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76137fa691e632245a36a06689eff1545f21a07573164f6fbf82ead3cf337f9c"
  end

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
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
      #include "uvwasi.h"

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