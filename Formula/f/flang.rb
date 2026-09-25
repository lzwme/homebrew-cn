class Flang < Formula
  desc "LLVM Fortran Frontend"
  homepage "https://flang.llvm.org/"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.2/llvm-project-23.1.2.src.tar.xz"
    sha256 "c98bbef08a2b4c2613cd50e9aa9ae7b69b1fe6c16b2c40373bc0ab6116fdf78a"

    resource "llvm_man_pages" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.2/llvm_man_pages-23.1.2.tar.xz"
      sha256 "bca1e2c6b58025dad7c5a589bc730e5bf10ff9920187861d41c16b6112a1ea61"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b02762374faceff6acc871d5110fd346796732db579eb1f07e04809c38d7d137"
    sha256 cellar: :any, arm64_tahoe:       "8053ba692a3382821f086183b10723c802f40d505c0eb852b2154476aaf95a62"
    sha256 cellar: :any, arm64_sequoia:     "c844e6e18ce9e26239a5851ff074c10e2d8339c5be5d87c61c0a474f6b4bbbcb"
    sha256 cellar: :any, arm64_linux:       "37ffdee805f9435020f6f4645b411dea33b5be5a00f34852bd7e1771e43c8070"
    sha256 cellar: :any, x86_64_linux:      "61b5a87807800dc8f3b667df897512483708337ec4548f00ea2902266f57b589"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "llvm"

  uses_from_macos "python" => :build

  fails_with :gcc do
    cause "needs 2x or more memory to build: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=119705"
  end

  def install
    llvm = Formula["llvm"]
    resource_dir = Pathname(Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp)
    relative_resource_dir = resource_dir.realpath.relative_path_from(llvm.prefix.realpath)
    clang_resource_dir = llvm.opt_prefix/relative_resource_dir
    flang_resource_dir = prefix/relative_resource_dir

    common_args = %W[
      -GNinja
      -DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm
      -DLLVM_ENABLE_FATLTO=ON
      -DLLVM_ENABLE_LTO=ON
    ]

    # LLVM_INSTALL_TOOLCHAIN_ONLY is to avoid shipping unnecessary libraries. Gentoo uses the same option.
    # Fedora builds as part of full LLVM so manually removes files after install to achieve a similar result:
    # https://src.fedoraproject.org/rpms/llvm/blob/821c6dcbd0d721d2c91e7c87bb4e483aaf1af715/f/llvm.spec#_2477-2523
    flang_args = %W[
      -DCLANG_DIR=#{llvm.opt_lib}/cmake/clang
      -DFLANG_INCLUDE_TESTS=OFF
      -DFLANG_REPOSITORY_STRING=#{tap&.issues_url}
      -DFLANG_VENDOR=#{tap&.user}
      -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
      -DLLVM_RAM_PER_COMPILE_JOB=5000
      -DLLVM_RAM_PER_LINK_JOB=10000
      -DLLVM_USE_SYMLINKS=ON
      -DMLIR_DIR=#{llvm.opt_lib}/cmake/mlir
    ]
    flang_args << "-DFLANG_VENDOR_UTI=sh.brew.flang" if tap&.official?

    flang_rt_args = %W[
      -DCMAKE_Fortran_COMPILER_WORKS=ON
      -DCMAKE_Fortran_COMPILER=#{bin}/flang
      -DFLANG_RT_ENABLE_SHARED=ON
      -DFLANG_RT_ENABLE_STATIC=ON
      -DFLANG_RT_INCLUDE_TESTS=OFF
      -DLIBOMP_FORTRAN_MODULES_ONLY=ON
      -DLLVM_BINARY_DIR=#{llvm.opt_prefix}
      -DLLVM_ENABLE_RUNTIMES=flang-rt;openmp
      -DLLVM_INCLUDE_TESTS=OFF
      -DOPENMP_ENABLE_OMPT_TOOLS=OFF
    ]

    system "cmake", "-S", "flang", "-B", "build", *flang_args, *common_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", "runtimes", "-B", "build-rt", *flang_rt_args, *common_args, *std_cmake_args
    system "cmake", "--build", "build-rt"
    system "cmake", "--install", "build-rt"

    if build.stable?
      resource("llvm_man_pages").stage do
        man1.install Utils::Gzip.compress("flang.1")
      end
    end

    # Add symlink to avoid extra RPATH on Linux. See if the upstream provides a better way of handling:
    # https://github.com/llvm/llvm-project/blob/main/flang-rt/cmake/modules/AddFlangRT.cmake#L379-L392
    lib.install_symlink flang_resource_dir.glob("lib/*/#{shared_library("*")}")

    # Remove the C/Fortran header that we manually install in `llvm` formula.
    header = "include/ISO_Fortran_binding.h"
    odie "Check on ISO_Fortran_binding.h!" unless identical?(clang_resource_dir/header, flang_resource_dir/header)
    rm(flang_resource_dir/header)
    rmdir(flang_resource_dir/"include") # intentionally not using rm_r to fail on new headers

    # Allow flang to find LLVM libraries as it expects them relative to driver
    symlink_src_paths = clang_resource_dir.glob("lib/**/*").select(&:file?) + [
      clang_resource_dir/"include",
      llvm.opt_lib/shared_library(OS.mac? ? "libLTO" : "LLVMgold"),
      llvm.opt_lib/shared_library("libomp"),
    ]
    symlink_src_paths.each { |src| (prefix/src.relative_path_from(llvm.opt_prefix)).make_relative_symlink src }
    (prefix/"etc").install_symlink etc/"clang"

    # FIXME: Flang 23 now installs Fortran modules into a path with macOS full kernel version.
    # As a workaround, we symlink into original path so they work across macOS security updates
    if OS.mac?
      triple = Utils.safe_popen_read(llvm.opt_bin/"clang", "--print-target-triple").chomp
      (include/"flang").install_symlink (flang_resource_dir/"finclude/flang"/triple).children
    end
  end

  test do
    (testpath/"sqrt72.f90").write <<~FORTRAN
      module m
      contains
        real(kind=kind(0.d0)) function f()
          f = 72.d0
          f = sqrt(f)
        end function f
      end module m
      program p
        use m
        real(kind=kind(0.d0)) :: r
        r = f()
        write(*,'(F12.6)') r
      end program p
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

    (testpath/"omptest.f90").write <<~FORTRAN
      PROGRAM omptest
      USE omp_lib
      !$OMP PARALLEL NUM_THREADS(4)
      WRITE(*,'(A,I1,A,I1)') 'Hello from thread ', OMP_GET_THREAD_NUM(), ', nthreads ', OMP_GET_NUM_THREADS()
      !$OMP END PARALLEL
      ENDPROGRAM
    FORTRAN

    (testpath/"runtimes.f90").write <<~FORTRAN
      Program main
        Complex :: y
        y = y/2
      End Program
    FORTRAN

    system bin/"flang", "-v", "-O2", "sqrt72.f90", "-o", "sqrt72"
    assert_equal "8.485281", shell_output("./sqrt72").strip

    system bin/"flang", "-v", "-flto", "test.f90", "-o", "test"
    assert_equal "Done", shell_output("./test").chomp

    system bin/"flang", "-v", "-fopenmp", "omptest.f90", "-o", "omptest"
    expected = (0..3).map { "Hello from thread #{it}, nthreads 4" }
    assert_equal expected, shell_output("./omptest").lines(chomp: true).sort

    system bin/"flang", "-v", "runtimes.f90"

    return if OS.linux?
    return unless (etc/"clang").exist? # https://github.com/Homebrew/homebrew-test-bot/issues/805

    assert_match %r{^Configuration file: .*/etc/clang/.*\.cfg$}i,
                 shell_output("#{bin}/flang --version")
  end
end