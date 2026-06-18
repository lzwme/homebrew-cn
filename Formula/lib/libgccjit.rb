class Libgccjit < Formula
  desc "JIT library for the GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.3.0/gcc-15.3.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.3.0/gcc-15.3.0.tar.xz"
    sha256 "fa59c1beef8995f27c4d71c1df227587189315d3e6faff1bb4306e61b0c530eb"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-15-branch
    patch do
      on_macos do
        file "Patches/gcc/gcc-15.3.0.diff"
      end
    end
  end

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "617eb7c5bd79bab2d19ac2a42bd28399ab6044c9dbdea8880a0cebccfdae190c"
    sha256 arm64_sequoia: "a1c9dcdbacf2cad9f761c49f36f9f59bfa06c7d9f27c5f491c99b529b16175b0"
    sha256 arm64_sonoma:  "dbcd58b7c8f1ca19a510d64ea3d2ca1875667419ece0059651fd85562ad57fcd"
    sha256 tahoe:         "f100f69f3f3b6438238532169cad541bca1c36617c4360c73748655b60f9d792"
    sha256 sequoia:       "21582e66d620470c899d08a68db907769902b22e9bbc772a7e163f79cec64d62"
    sha256 sonoma:        "9cf40af8d91e894dad6e4f7d81c5edcdcf5a8e04f8ebd4f7d7397bc5daa533e5"
    sha256 arm64_linux:   "2628cfd0e032d6667726fbe79b993334191dc5cba9a9ecbeefb1bf50f57b60cd"
    sha256 x86_64_linux:  "be10716dfc386631bda6c895f018c8609961b50ae55371264bc58313878999e8"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on "gcc" => :test
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  on_macos do
    on_intel do
      depends_on "gcc"
    end
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    # Use `lib/gcc/current` to align with the GCC formula.
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/current
      --disable-nls
      --enable-checking=release
      --with-gcc-major-version-only
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-zstd=#{Formula["zstd"].opt_prefix}
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
      --with-system-zlib
    ]

    if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      args << "--with-sysroot=#{sdk}" if sdk

      # Avoid this semi-random failure:
      # "Error: Failed changing install name"
      # "Updated load commands do not fit in the header"
      ldflags = %w[-Wl,-headerpad_max_install_names]

      # Fix linkage with `libgcc_s.1.1`. See: https://github.com/orgs/Homebrew/discussions/5364
      if Hardware::CPU.intel?
        ldflags << "-Wl,-rpath,#{rpath(source: lib/"gcc/current", target: Formula["gcc"].opt_lib/"gcc/current")}"
      end

      make_args = %W[BOOT_LDFLAGS=#{ldflags.join(" ")}]
    else
      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
      inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="

      ENV.append_path "CPATH", Formula["zlib-ng-compat"].opt_include
      ENV.append_path "LIBRARY_PATH", Formula["zlib-ng-compat"].opt_lib
    end

    # Building jit needs --enable-host-shared, which slows down the compiler.
    mkdir "build-jit" do
      system "../configure", *args, "--enable-languages=jit", "--enable-host-shared"
      system "make", *make_args
      system "make", "install"
    end

    # We only install the relevant libgccjit files from libexec and delete the rest.
    prefix.find do |f|
      rm_r(f) if !f.directory? && !f.basename.to_s.start_with?("libgccjit")
    end

    # Provide a `lib/gcc/xy` directory to align with the versioned GCC formulae.
    (lib/"gcc"/version.major).install_symlink (lib/"gcc/current").children
  end

  test do
    (testpath/"test-libgccjit.c").write <<~C
      #include <libgccjit.h>
      #include <stdlib.h>
      #include <stdio.h>

      static void create_code (gcc_jit_context *ctxt) {
          gcc_jit_type *void_type = gcc_jit_context_get_type (ctxt, GCC_JIT_TYPE_VOID);
          gcc_jit_type *const_char_ptr_type = gcc_jit_context_get_type (ctxt, GCC_JIT_TYPE_CONST_CHAR_PTR);
          gcc_jit_param *param_name = gcc_jit_context_new_param (ctxt, NULL, const_char_ptr_type, "name");
          gcc_jit_function *func = gcc_jit_context_new_function (ctxt, NULL, GCC_JIT_FUNCTION_EXPORTED,
                  void_type, "greet", 1, &param_name, 0);
          gcc_jit_param *param_format = gcc_jit_context_new_param (ctxt, NULL, const_char_ptr_type, "format");
          gcc_jit_function *printf_func = gcc_jit_context_new_function (ctxt, NULL, GCC_JIT_FUNCTION_IMPORTED,
                  gcc_jit_context_get_type (ctxt, GCC_JIT_TYPE_INT), "printf", 1, &param_format, 1);
          gcc_jit_rvalue *args[2];
          args[0] = gcc_jit_context_new_string_literal (ctxt, "hello %s");
          args[1] = gcc_jit_param_as_rvalue (param_name);
          gcc_jit_block *block = gcc_jit_function_new_block (func, NULL);
          gcc_jit_block_add_eval (block, NULL, gcc_jit_context_new_call (ctxt, NULL, printf_func, 2, args));
          gcc_jit_block_end_with_void_return (block, NULL);
      }

      int main (int argc, char **argv) {
          gcc_jit_context *ctxt;
          gcc_jit_result *result;
          ctxt = gcc_jit_context_acquire ();
          if (!ctxt) {
              fprintf (stderr, "NULL ctxt");
              exit (1);
          }
          gcc_jit_context_set_bool_option (ctxt, GCC_JIT_BOOL_OPTION_DUMP_GENERATED_CODE, 0);
          create_code (ctxt);
          result = gcc_jit_context_compile (ctxt);
          if (!result) {
              fprintf (stderr, "NULL result");
              exit (1);
          }
          typedef void (*fn_type) (const char *);
          fn_type greet = (fn_type)gcc_jit_result_get_code (result, "greet");
          if (!greet) {
              fprintf (stderr, "NULL greet");
              exit (1);
          }
          greet ("world");
          fflush (stdout);
          gcc_jit_context_release (ctxt);
          gcc_jit_result_release (result);
          return 0;
      }
    C

    gcc_major_ver = Formula["gcc"].any_installed_version.major
    gcc = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
    libs = HOMEBREW_PREFIX/"lib/gcc/current"
    test_flags = %W[-I#{include} test-libgccjit.c -o test -L#{libs} -lgccjit]

    system gcc.to_s, *test_flags
    assert_equal "hello world", shell_output("./test")

    # The test below fails with the host compiler on Linux.
    return if OS.linux?

    # Also test with the host compiler, which many users use with libgccjit
    (testpath/"test").unlink
    system ENV.cc, *test_flags
    assert_equal "hello world", shell_output("./test")
  end
end