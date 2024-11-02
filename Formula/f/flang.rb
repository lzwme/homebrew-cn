class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https:flang.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.3llvm-project-19.1.3.src.tar.xz"
  sha256 "324d483ff0b714c8ce7819a1b679dd9e4706cf91c6caf7336dc4ac0c1d3bf636"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdd2c87834a1ec92f4d87d8c0703c2e7bdfd15cadc72174fd768962f174588f1"
    sha256 cellar: :any,                 arm64_sonoma:  "ecf637bff4bd02c2c4c77344603a065f6b61310eb1243869c9e0e17002f1d06c"
    sha256 cellar: :any,                 arm64_ventura: "2683519b08dd29be67ac74e10dce1bff82133c25ab3a8f3ea83a0ce32628b4bf"
    sha256 cellar: :any,                 sonoma:        "48b935fdba8b67b0efa4f2a292d9dc0ebf0d60b45972f25f476e51f2e98612df"
    sha256 cellar: :any,                 ventura:       "9cc0bd144901f4261199a629a5adc712204cac15241e0ddb1bcf517cad896ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9157954980e2051622073b1252c7db1ca504764fc351ae2e17b6f582305f68f6"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
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
      -G Ninja
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
    # Linking takes an absurd amount of memory. Try to limit it to no more than 4GB per link job.
    args << "-DLLVM_RAM_PER_LINK_JOB=#{4 * 1024}" if ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    ENV.append_to_cflags "-ffat-lto-objects" if OS.linux? # Unsupported on macOS.
    install_prefix = libexec
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args(install_prefix:)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.find do |pn|
      next if pn.directory?

      subdir = pn.relative_path_from(libexec).dirname
      (prefixsubdir).install_symlink pn
    end

    # Our LLVM is built with exception-handling, which requires linkage with the C++ standard library.
    # TODO: Remove this ifwhen we've rebuilt LLVM with `LLVM_ENABLE_EH=OFF`.
    cxx_stdlib = OS.mac? ? "-lc++" : "-lstdc++"
    cxx_stdlib << "\n"
    (libexec"binflang.cfg").atomic_write cxx_stdlib

    return if OS.linux?

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

    # The `flang-new` driver expects `libLTO.dylib` to be in the same prefix,
    # but it actually lives in LLVM's prefix.
    ln_sf Formula["llvm"].opt_libshared_library("libLTO"), install_prefix"lib"
  end

  def caveats
    <<~EOS
      Homebrew LLVM is built with LLVM_ENABLE_EH=ON, so binaries built by `#{flang_driver}`
      require linkage to the C++ standard library. `#{flang_driver}` is configured to do this
      automatically.
    EOS
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