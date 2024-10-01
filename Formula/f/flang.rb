class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https:flang.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.0llvm-project-19.1.0.src.tar.xz"
  sha256 "5042522b49945bc560ff9206f25fb87980a9b89b914193ca00d961511ff0673c"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "48c32f1d7bfe4fc9f793b51b139b87060230ee31a30908bae9e0670d9b580a21"
    sha256 cellar: :any,                 arm64_sonoma:  "c791ae601e361b2a4073238ad07b19e4ab188ddfc37e82f95adb05ab0085b4e8"
    sha256 cellar: :any,                 arm64_ventura: "ed73d7e80372c6a9867d961aac012f4a1de50418cb170a9bbff6cfb48b2ece6a"
    sha256 cellar: :any,                 sonoma:        "fa68872e1fa3661da7cf68ab7b9094cfe2b8c751ef189172a2b15359c3b26abc"
    sha256 cellar: :any,                 ventura:       "a497d4a231bbd6426657a4e6d5b64e8840b42c5bdba8b8d47cc7accdfe300e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "865098e0774cbe9b78399747b9949cb5522912649517f54f6bad4f03c31b9482"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"
  uses_from_macos "zlib"

  def llvm
    Formula["llvm"]
  end

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

  def install
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
    install_prefix = OS.mac? ? libexec : prefix
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args(install_prefix:)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return if install_prefix == prefix

    # Convert LTO-generated bitcode in our static archives to MachO.
    # Not needed on Linux because of `-ffat-lto-objects`
    # See equivalent code in `llvm.rb`.
    install_prefix.glob("lib*.a").each do |static_archive|
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

    libexec.find do |pn|
      next if pn.directory?

      subdir = pn.relative_path_from(libexec).dirname
      (prefixsubdir).install_symlink pn
    end

    # The `flang-new` driver expects `libLTO.dylib` to be in the same prefix,
    # but it actually lives in LLVM's prefix.
    liblto = Formula["llvm"].opt_libshared_library("libLTO")
    ln_sf liblto, libexec"lib"
  end

  test do
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

    cxx_stdlib = OS.mac? ? "-lc++" : "-lstdc++"

    system bin"flang-new", "-v", "hello.f90", cxx_stdlib, "-o", "hello"
    assert_equal "Hello World!", shell_output(".hello").chomp

    system bin"flang-new", "-v", "test.f90", cxx_stdlib, "-o", "test"
    assert_equal "Done", shell_output(".test").chomp

    system "ar", "x", lib"libFortranCommon.a"
    testpath.glob("*.o").each do |object_file|
      refute_match(^LLVM (IR )?bitcode, shell_output("file --brief #{object_file}"))
    end
  end
end