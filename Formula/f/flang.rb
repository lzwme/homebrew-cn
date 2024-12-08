class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https:flang.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5llvm-project-19.1.5.src.tar.xz"
  sha256 "bd8445f554aae33d50d3212a15e993a667c0ad1b694ac1977f3463db3338e542"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4af701ed1866d1d903c4ebbb4a17399f062d2bc2c31a0acd18bcdcd70917c46"
    sha256 cellar: :any,                 arm64_sonoma:  "c5a53e7138df4eac5453b2423e7156035e2909c6a1843aeb81798a272363902a"
    sha256 cellar: :any,                 arm64_ventura: "4083e56d3d30414b66e287438e16acdf3032702ce6c4853edc363a5cd75b356b"
    sha256 cellar: :any,                 sonoma:        "72e7fcd1e3d092457833ccb8a346f548bfcad41df19e82dee6a7a2f851f4df4c"
    sha256 cellar: :any,                 ventura:       "8647c89845a0026fa3c21e88d4a7dcac050830275fd117e91d15690b23c51dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "975f0a27327201f8641844d04fab2b0af88e022b01aa9c07a1a1f031113386cb"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

  def flang_driver
    "flang-new"
  end

  def install
    llvm = Formula["llvm"]
    # NOTE: Setting `BUILD_SHARED_LIBRARIES=ON` causes the just-built flang to throw ICE.
    args = %W[
      -DCLANG_DIR=#{llvm.opt_lib}cmakeclang
      -DFLANG_INCLUDE_TESTS=OFF
      -DFLANG_REPOSITORY_STRING=#{tap&.issues_url}
      -DFLANG_STANDALONE_BUILD=ON
      -DFLANG_VENDOR=#{tap&.user}
      -DLLVM_DIR=#{llvm.opt_lib}cmakellvm
      -DLLVM_ENABLE_EH=OFF
      -DLLVM_ENABLE_LTO=ON
      -DLLVM_USE_SYMLINKS=ON
      -DMLIR_DIR=#{llvm.opt_lib}cmakemlir
    ]
    args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?

    ENV.append_to_cflags "-ffat-lto-objects" if OS.linux? # Unsupported on macOS.
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children

    # Our LLVM is built with exception-handling, which requires linkage with the C++ standard library.
    # TODO: Remove this ifwhen we've rebuilt LLVM with `LLVM_ENABLE_EH=OFF`.
    flang_cfg_file = if OS.mac?
      ["-lc++", "-Wl,-lto_library,#{llvm.opt_lib}libLTO.dylib"]
    else
      ["-lstdc++"]
    end
    (libexec"flang.cfg").atomic_write flang_cfg_file.join("\n")

    return if OS.linux?

    # Convert LTO-generated bitcode in our static archives to MachO.
    # Not needed on Linux because of `-ffat-lto-objects`
    # See equivalent code in `llvm.rb`.
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system llvm.opt_bin"llvm-ar", "x", static_archive
        rebuilt_files = []

        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", "--brief", bc_file)
          next unless file_type.match?(^LLVM (IR )?bitcode)

          rebuilt_files << bc_file
          system ENV.cc, "-fno-lto", "-Wno-unused-command-line-argument",
                         "-x", "ir", bc_file, "-c", "-o", bc_file
        end

        system llvm.opt_bin"llvm-ar", "r", static_archive, *rebuilt_files if rebuilt_files.present?
      end
    end
  end

  def caveats
    <<~EOS
      Homebrew LLVM is built with LLVM_ENABLE_EH=ON, so binaries built by `#{flang_driver}`
      require linkage to the C++ standard library. `#{flang_driver}` is configured to do this
      automatically.
    EOS
  end

  test do
    # FIXME: We should remove the two variables below from the environment
    #        to test that `flang` can find our config files correctly, but
    #        this seems to break CI (but can't be reproduced locally).
    # ENV.delete "CPATH"
    # ENV.delete "SDKROOT"

    (testpath"hello.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    (testpath"test.f90").write <<~FORTRAN
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    FORTRAN

    system binflang_driver, "-v", "hello.f90", "-o", "hello"
    assert_equal "Hello World!", shell_output(".hello").chomp

    system binflang_driver, "-v", "test.f90", "-o", "test"
    assert_equal "Done", shell_output(".test").chomp

    system "ar", "x", lib"libFortranCommon.a"
    testpath.glob("*.o").each do |object_file|
      refute_match(^LLVM (IR )?bitcode, shell_output("file --brief #{object_file}"))
    end
  end
end