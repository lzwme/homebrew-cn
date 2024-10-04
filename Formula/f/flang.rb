class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https:flang.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.1llvm-project-19.1.1.src.tar.xz"
  sha256 "d40e933e2a208ee142898f85d886423a217e991abbcd42dd8211f507c93e1266"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8c19642094226f3747877879c38f28d8234ea60a66116d5f0746513597c911a0"
    sha256 cellar: :any,                 arm64_sonoma:  "3cc8c6d272d3b4134ec1686a694cba57d9048247d63339b95431d36154272526"
    sha256 cellar: :any,                 arm64_ventura: "36ae2867b2b8ae3c043a28b9a01ab15b479506f74b998393549aa3affa951245"
    sha256 cellar: :any,                 sonoma:        "33daec5a65f9ff33dadfa3daabd36bbc9cfbef65fa21a6bbb0d2b2053175547a"
    sha256 cellar: :any,                 ventura:       "3dc9bb74ab722231bdcc3cf12ff5dbd401708740e41f3f295bf45f2156a9bc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12de15e093df57abef3f592e498915c6bbed9d89ac2d4b395568c881f1896927"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

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