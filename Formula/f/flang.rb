class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https:flang.llvm.org"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.2llvm-project-20.1.2.src.tar.xz"
  sha256 "f0a4a240aabc9b056142d14d5478bb6d962aeac549cbd75b809f5499240a8b38"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comllvmllvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00c50446452260abf7a51342dcbfb3773232922879c1a8a0b3d913a26cee0099"
    sha256 cellar: :any,                 arm64_sonoma:  "a80fff8380650c7baba0fea1a47929fc56a57d069546b8d818e8ef6e2b708560"
    sha256 cellar: :any,                 arm64_ventura: "2b3e6fc4790138b3cfe4eae2108bc9532ac28d1b2ee2919c9d609d0890080af2"
    sha256 cellar: :any,                 sonoma:        "8f2015416971cc68ad78c684004d12bc66ab5f88a2f14323a6ff789db47d2712"
    sha256 cellar: :any,                 ventura:       "01909576e54190c55c060e7d5feb60771f5ceb357247221f73b1351b2225bff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a9b085e052dc177c27cb333edb29d2208bebac1e01e532e88b76ac4bbb1d2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9078ab8a1ecd47810ad1952aeba8bc314dced510cfb3f49edad85b0fd20148c"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

  def flang_driver
    "flang-new"
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Generate omp_lib.h and omp_lib.F90 to be used by flang build
    system "cmake", "-S", "openmp", "-B", "buildprojectsopenmp", *std_cmake_args

    args = %W[
      -DLLVM_TOOL_OPENMP_BUILD=ON
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
      -DMLIR_LINK_MLIR_DYLIB=ON
    ]
    args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?
    # FIXME: Setting `BUILD_SHARED_LIBS=ON` causes the just-built flang to throw ICE on macOS
    args << "-DBUILD_SHARED_LIBS=ON" if OS.linux?

    ENV.append_to_cflags "-ffat-lto-objects" if OS.linux? # Unsupported on macOS.
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    return if OS.linux?

    libexec.install bin.children
    bin.install_symlink libexec.children

    # Help `flang-new` driver find `libLTO.dylib` and runtime libraries
    resource_dir = Utils.safe_popen_read(llvm.opt_bin"clang", "-print-resource-dir").chomp
    resource_dir.gsub!(llvm.prefix.realpath, llvm.opt_prefix)
    (libexec"flang.cfg").atomic_write <<~CONFIG
      -Wl,-lto_library,#{llvm.opt_lib}libLTO.dylib
      -resource-dir=#{resource_dir}
    CONFIG

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

    (testpath"omptest.f90").write <<~FORTRAN
      PROGRAM omptest
      USE omp_lib
      !$OMP PARALLEL NUM_THREADS(4)
      WRITE(*,'(A,I1,A,I1)') 'Hello from thread ', OMP_GET_THREAD_NUM(), ', nthreads ', OMP_GET_NUM_THREADS()
      !$OMP END PARALLEL
      ENDPROGRAM
    FORTRAN

    openmp_flags = %w[-fopenmp]
    openmp_flags += if OS.mac?
      %W[-L#{llvm.opt_lib}]
    else
      libomp_dir = llvm.opt_libUtils.safe_popen_read(llvm.opt_bin"clang", "--print-target-triple").chomp
      %W[-L#{libomp_dir} -Wl,-rpath,#{libomp_dir} -Wl,-rpath,#{lib}]
    end
    system binflang_driver, "-v", *openmp_flags, "omptest.f90", "-o", "omptest"
    testresult = shell_output(".omptest")

    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    sorted_testresult = testresult.split("\n").sort.join("\n")
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath"runtimes.f90").write <<~FORTRAN
      Program main
        Complex :: y
        y = y2
      End Program
    FORTRAN
    system binflang_driver, "-v", "runtimes.f90"

    return if OS.linux?

    system "ar", "x", lib"libFortranCommon.a"
    testpath.glob("*.o").each do |object_file|
      refute_match(^LLVM (IR )?bitcode, shell_output("file --brief #{object_file}"))
    end
  end
end