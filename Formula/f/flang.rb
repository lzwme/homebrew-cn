class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https://flang.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/llvm-project-20.1.7.src.tar.xz"
  sha256 "cd8fd55d97ad3e360b1d5aaf98388d1f70dfffb7df36beee478be3b839ff9008"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb8bdf145609cb4985131f7e45f8d0c6735599c63400ede5723de5616a1b8b65"
    sha256 cellar: :any,                 arm64_sonoma:  "a2cf6d74f7eadb6266f27257177bfa90322a4607a5669b8c478e5c30277bf2b6"
    sha256 cellar: :any,                 arm64_ventura: "555605364bc7e69b8156b27aa767eeb397507a7e979a33a2c8d313840f5ad36f"
    sha256 cellar: :any,                 sonoma:        "e7538a19ba1b7d974f4751577910bf1ba40891f29cb98d6d4b44ccc95b7c9227"
    sha256 cellar: :any,                 ventura:       "f28215f5f8565162b5ae11bc606b2c2e708d1d160e6d4dc1092e252463ac64bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2f7a4db843708f30fa3fd03e7517867dc4661e81d594b3467775efdd0d3a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "894bcc0efd88abc11cfe42cd2faac08dd6859c7df5cb499b9718454e0b02a3a5"
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
    system "cmake", "-S", "openmp", "-B", "build/projects/openmp", *std_cmake_args

    args = %W[
      -DLLVM_TOOL_OPENMP_BUILD=ON
      -DCLANG_DIR=#{llvm.opt_lib}/cmake/clang
      -DFLANG_INCLUDE_TESTS=OFF
      -DFLANG_REPOSITORY_STRING=#{tap&.issues_url}
      -DFLANG_STANDALONE_BUILD=ON
      -DFLANG_VENDOR=#{tap&.user}
      -DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm
      -DLLVM_ENABLE_EH=OFF
      -DLLVM_ENABLE_LTO=ON
      -DLLVM_USE_SYMLINKS=ON
      -DMLIR_DIR=#{llvm.opt_lib}/cmake/mlir
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
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub!(llvm.prefix.realpath, llvm.opt_prefix)
    (libexec/"flang.cfg").atomic_write <<~CONFIG
      -Wl,-lto_library,#{llvm.opt_lib}/libLTO.dylib
      -resource-dir=#{resource_dir}
    CONFIG

    # Convert LTO-generated bitcode in our static archives to MachO.
    # Not needed on Linux because of `-ffat-lto-objects`
    # See equivalent code in `llvm.rb`.
    lib.glob("*.a").each do |static_archive|
      mktemp do
        system llvm.opt_bin/"llvm-ar", "x", static_archive
        rebuilt_files = []

        Pathname.glob("*.o").each do |bc_file|
          file_type = Utils.safe_popen_read("file", "--brief", bc_file)
          next unless file_type.match?(/^LLVM (IR )?bitcode/)

          rebuilt_files << bc_file
          system ENV.cc, "-fno-lto", "-Wno-unused-command-line-argument",
                         "-x", "ir", bc_file, "-c", "-o", bc_file
        end

        system llvm.opt_bin/"llvm-ar", "r", static_archive, *rebuilt_files if rebuilt_files.present?
      end
    end
  end

  test do
    # FIXME: We should remove the two variables below from the environment
    #        to test that `flang` can find our config files correctly, but
    #        this seems to break CI (but can't be reproduced locally).
    # ENV.delete "CPATH"
    # ENV.delete "SDKROOT"

    (testpath/"hello.f90").write <<~FORTRAN
      PROGRAM hello
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    FORTRAN

    (testpath/"test.f90").write <<~FORTRAN
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    FORTRAN

    system bin/flang_driver, "-v", "hello.f90", "-o", "hello"
    assert_equal "Hello World!", shell_output("./hello").chomp

    system bin/flang_driver, "-v", "test.f90", "-o", "test"
    assert_equal "Done", shell_output("./test").chomp

    (testpath/"omptest.f90").write <<~FORTRAN
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
      libomp_dir = llvm.opt_lib/Utils.safe_popen_read(llvm.opt_bin/"clang", "--print-target-triple").chomp
      %W[-L#{libomp_dir} -Wl,-rpath,#{libomp_dir} -Wl,-rpath,#{lib}]
    end
    system bin/flang_driver, "-v", *openmp_flags, "omptest.f90", "-o", "omptest"
    testresult = shell_output("./omptest")

    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    sorted_testresult = testresult.split("\n").sort.join("\n")
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"runtimes.f90").write <<~FORTRAN
      Program main
        Complex :: y
        y = y/2
      End Program
    FORTRAN
    system bin/flang_driver, "-v", "runtimes.f90"

    return if OS.linux?

    system "ar", "x", lib/"libFortranCommon.a"
    testpath.glob("*.o").each do |object_file|
      refute_match(/^LLVM (IR )?bitcode/, shell_output("file --brief #{object_file}"))
    end
  end
end