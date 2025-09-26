class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https://flang.llvm.org/"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/llvm-project-21.1.2.src.tar.xz"
  sha256 "1a417d1c8faf8d93e73fec1cbb76d393ed3218974c2283c7bac9672d3d47c54b"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c91e58577f13f6cfc11b2eda471cfbf80eba7db0e0ae1aa8088171bdfa326b03"
    sha256 cellar: :any,                 arm64_sequoia: "4fe6b6b610039a51ad4dc2b2291dc3e1a775d34ef8cadbd3f78402358747e9f2"
    sha256 cellar: :any,                 arm64_sonoma:  "14137247164764f19a1ee964be23c0041834f56935b47371c3184c69f2eb011e"
    sha256 cellar: :any,                 sonoma:        "6bd1393305710170662cd38ba22d8510945f208786adfab9b14edcb73bafb653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9bae0382b158ccfc8ceb8ecd4f263b771680d0c717e7e61b684a799930afa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae008637939216b09edd9bf44f95f18d6e60b0fb8f185216b207e550d0fd666"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"

  # Keep broken symlink if `llvm` has been unlinked on Linux.
  skip_clean "lib/LLVMgold.so"

  # Building with GCC fails at linking with an obscure error.
  fails_with :gcc

  def llvm
    Formula["llvm"]
  end

  def install
    resource_dir = Pathname(Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp)
    relative_resource_dir = resource_dir.relative_path_from(llvm.prefix.realpath)

    common_args = %W[
      -GNinja
      -DBUILD_SHARED_LIBS=ON
      -DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm
      -DLLVM_ENABLE_FATLTO=ON
      -DLLVM_ENABLE_LTO=ON
    ]

    flang_args = %W[
      -DCLANG_DIR=#{llvm.opt_lib}/cmake/clang
      -DFLANG_INCLUDE_TESTS=OFF
      -DFLANG_REPOSITORY_STRING=#{tap&.issues_url}
      -DFLANG_VENDOR=#{tap&.user}
      -DLLVM_RAM_PER_COMPILE_JOB=5000
      -DLLVM_TOOL_OPENMP_BUILD=ON
      -DLLVM_USE_SYMLINKS=ON
      -DMLIR_DIR=#{llvm.opt_lib}/cmake/mlir
      -DMLIR_LINK_MLIR_DYLIB=ON
    ]
    flang_args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?

    flang_rt_args = %W[
      -DCMAKE_Fortran_COMPILER_WORKS=ON
      -DCMAKE_Fortran_COMPILER=#{bin}/flang
      -DFLANG_RT_ENABLE_SHARED=ON
      -DFLANG_RT_ENABLE_STATIC=OFF
      -DFLANG_RT_INCLUDE_TESTS=OFF
      -DLLVM_BINARY_DIR=#{llvm.opt_prefix}
      -DLLVM_ENABLE_RUNTIMES=flang-rt
    ]

    # Generate omp_lib.h and omp_lib.F90 to be used by flang build
    system "cmake", "-S", "openmp", "-B", "build/projects/openmp", *std_cmake_args

    system "cmake", "-S", "flang", "-B", "build", *flang_args, *common_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", "runtimes", "-B", "build-rt", *flang_rt_args, *common_args, *std_cmake_args
    system "cmake", "--build", "build-rt"
    system "cmake", "--install", "build-rt"

    # Add symlink for runtime library as it won't be found when resource-dir is
    # overridden by flang.cfg. This also allows shared `flang-rt` on Linux to
    # avoid extra RPATH. See if the upstream provides a better way of handling:
    # https://github.com/llvm/llvm-project/blob/main/flang-rt/CMakeLists.txt#L120-L130
    lib.install_symlink (prefix/relative_resource_dir).glob("**/#{shared_library("*")}")

    # Allow flang -flto to work on Linux as it expects library relative to driver.
    # The HOMEBREW_PREFIX path is used so that `brew link` skips creating a symlink.
    lib.install_symlink HOMEBREW_PREFIX/"lib/LLVMgold.so" if OS.linux?

    libexec.install bin.children
    bin.install_symlink libexec.children

    # Help `flang` driver find `libLTO.dylib` and runtime libraries
    # TODO: Try using CLANG_RESOURCE_DIR when building `llvm`
    configs = ["-resource-dir=#{llvm.opt_prefix/relative_resource_dir}"]
    configs << "-Wl,-lto_library,#{llvm.opt_lib}/libLTO.dylib" if OS.mac?
    (libexec/"flang.cfg").atomic_write "#{configs.join("\n")}\n"
  end

  test do
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

    system bin/"flang", "-v", "hello.f90", "-o", "hello"
    assert_equal "Hello World!", shell_output("./hello").chomp

    system bin/"flang", "-v", "-flto", "test.f90", "-o", "test"
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
    system bin/"flang", "-v", *openmp_flags, "omptest.f90", "-o", "omptest"
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
    system bin/"flang", "-v", "runtimes.f90"

    return if OS.linux?
    return unless (etc/"clang").exist? # https://github.com/Homebrew/homebrew-test-bot/issues/805

    assert_match %r{^Configuration file: #{Regexp.escape(etc)}/clang/.*\.cfg$}i,
                 shell_output("#{bin}/flang --version")
  end
end