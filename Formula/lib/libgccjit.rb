class Libgccjit < Formula
  desc "JIT library for the GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  head "https://gcc.gnu.org/git/gcc.git", branch: "master"

  stable do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
    sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"

    # Branch from the Darwin maintainer of GCC, with a few generic fixes and
    # Apple Silicon support, located at https://github.com/iains/gcc-14-branch
    patch do
      on_macos do
        url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/575ffcaed6d3112916fed77d271dd3799a7255c4/gcc/gcc-15.1.0.diff"
        sha256 "360fba75cd3ab840c2cd3b04207f745c418df44502298ab156db81d41edf3594"
      end
    end
  end

  livecheck do
    formula "gcc"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7287477cc3c67e3289f770ee9c70fddfb39f6ea7b925fdb775b54939b22e0910"
    sha256 arm64_sequoia: "04adeecfca5beafcb7964f2138093b90908b5b04aa066e15cd7e5c76428b2ac8"
    sha256 arm64_sonoma:  "86fa84fb07098a91ff9a8cc82982ba74dcd1357bb6b807dabecd2c078e7950c3"
    sha256 arm64_ventura: "3e2ba2afd658bafda72aa3a4e86b49f6d973f3779b222675a3a9d2905c23a7ed"
    sha256 tahoe:         "49106c901073c01fc896a1c3c1ec4dda945314b837e67f64945841ae569a27e1"
    sha256 sequoia:       "c66b7245b953b1de3d9519789397e879ae0ca311e4f7e80ff4e50eabc24a19d4"
    sha256 sonoma:        "bc109320edce03d46fa5a4322e8c5a9c43b9531f0321f6137883c5df0b996660"
    sha256 ventura:       "9095eb6c8ec935270bb81ec510b2867885144eb4a0efa9d87d94976dc762cc9e"
    sha256 arm64_linux:   "4f45551e36c7171a4242446993d30b35189b3fe255a287c4148e1215a28c0bfc"
    sha256 x86_64_linux:  "0b0e73bb044bb3988e3ddc28b19b8da64bed6e95ade603d49fee748f1f086d06"
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

  uses_from_macos "zlib"

  on_macos do
    on_intel do
      depends_on "gcc"
    end
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
      make_args = %w[BOOT_LDFLAGS=-Wl,-headerpad_max_install_names]
    else
      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # https://stackoverflow.com/a/54038769
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
      inreplace "gcc/config/aarch64/t-aarch64-linux", "lp64=../lib64", "lp64="

      ENV.append_path "CPATH", Formula["zlib"].opt_include
      ENV.append_path "LIBRARY_PATH", Formula["zlib"].opt_lib
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

    return if OS.linux? || Hardware::CPU.arm?

    lib.glob("gcc/current/#{shared_library("libgccjit", "*")}").each do |dylib|
      next if dylib.symlink?

      # Fix linkage with `libgcc_s.1.1`. See: Homebrew/discussions#5364
      gcc_libdir = Formula["gcc"].opt_lib/"gcc/current"
      MachO::Tools.add_rpath(dylib, rpath(source: lib/"gcc/current", target: gcc_libdir))
    end
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