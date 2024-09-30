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
    sha256 cellar: :any, arm64_sequoia: "f4cc33b60eec6295c5bce880a6bfeeb77b9b42bc3c59914c38f9fefecacf0ae8"
    sha256 cellar: :any, arm64_sonoma:  "216ed0ba35c0aede3d0b7edb13c20425574a31c4ac8b2f9e1023e8c6fcbc0861"
    sha256 cellar: :any, arm64_ventura: "447a15f0b773bf097f158181c57ff0568c07b5476929af4d8aa7add8c81cf02d"
    sha256 cellar: :any, sonoma:        "d95b30baa99589aab50c01d91e26eee3e866c07600052646a4033803e7b32a8b"
    sha256 cellar: :any, ventura:       "7830c67c89f757c1196d1240205ec22cf00b2bc969bc70514c026bff0d919355"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "zstd"
  uses_from_macos "zlib"

  def llvm
    Formula["llvm"]
  end

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

    install_prefix = OS.mac? ? libexec : prefix
    system "cmake", "-S", "flang", "-B", "build", *args, *std_cmake_args(install_prefix:)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    return if install_prefix == prefix

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
  end
end