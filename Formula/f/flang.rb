class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https:flang.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4llvm-project-19.1.4.src.tar.xz"
  sha256 "3aa2d2d2c7553164ad5c6f3b932b31816e422635e18620c9349a7da95b98d811"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "64afb762797a80e904664d45eaeec75dba3258ebc45b7fdd2ffeb9cdfdb2c839"
    sha256 cellar: :any,                 arm64_sonoma:  "6f54cdb28b2c9ae7cc66c00471289de9938269d673f7512b2e7902733267dc31"
    sha256 cellar: :any,                 arm64_ventura: "9740ace041070a1e2d81bd2fb4191519de75f5688ef9cbd7a840df2345491d04"
    sha256 cellar: :any,                 sonoma:        "4de46ab7e6a4d0ce4239f046e210fc022a1a620e6be1d5be3e93789e0c35dea9"
    sha256 cellar: :any,                 ventura:       "61961b1c1151570fae69a992afe4097d6501c073bbd8d40f16e262550968b88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18f4588ee5f9c9af26e4b5038b714c8760efaedea39ba19a9337efa9e2a7e51"
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
    ENV.delete "CPATH"
    ENV.delete "SDKROOT"

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