class Klee < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Symbolic Execution Engine"
  homepage "https:klee-se.org"
  url "https:github.comkleekleearchiverefstagsv3.0.tar.gz"
  sha256 "204ebf0cb739886f574b1190b04fa9ed9088770c0634984782e9633d1aa4bdc9"
  license "NCSA"
  revision 2
  head "https:github.comkleeklee.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "20a94127e1cd812fe8d1fdafa544d16fc1d4f8e3dc4309c3a798616603b27421"
    sha256 arm64_ventura:  "aff91c5cde3b1560b734d0a4053c0f4e9a0db404f5cce46de2b8af58a13bda3a"
    sha256 arm64_monterey: "520358584e40a77f6578d0d788f05e4c7028c40b2d416e3fafad21f348dd3612"
    sha256 sonoma:         "c29106dec09329ae47ba9b8c0852380b92fca1294722d55af62a1aac7dc4fafa"
    sha256 ventura:        "d2b6d81c8a13b81e572f9867421a16474d1dfeb10f26ee23cc19733cc8383c3b"
    sha256 monterey:       "fb47d3def09cd573cb36e09e05924a04867b5662822ae768365640429b3dc89a"
    sha256 x86_64_linux:   "c9eb15b2ae11c897e88fef23d0ed05243dbe162b6679ea18c32ae03fc499975a"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "llvm@14" # LLVM 16 PR: https:github.comkleekleepull1664
  depends_on "python@3.12"
  depends_on "sqlite"
  depends_on "stp"
  depends_on "wllvm"
  depends_on "z3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "python-setuptools" => :build # Remove with LLVM 15+
  end

  fails_with gcc: "5"

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-14.0.6llvm-project-14.0.6.src.tar.xz"
    sha256 "8b3cfd7bc695bd6cea0f37f53f0981f34f87496e79e2529874fd03a2f9dd3a8a"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    libcxx_install_dir = libexec"libcxx"
    libcxx_src_dir = buildpath"libcxx"
    resource("libcxx").stage libcxx_src_dir

    # Use build configuration at
    # https:github.comkleekleeblobv#{version}scriptsbuildp-libcxx.inc
    libcxx_args = std_cmake_args(install_prefix: libcxx_install_dir) + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ENABLE_PROJECTS=libcxx;libcxxabi
      -DLLVM_ENABLE_THREADS:BOOL=OFF
      -DLLVM_ENABLE_EH:BOOL=OFF
      -DLLVM_ENABLE_RTTI:BOOL=OFF
      -DLIBCXX_ENABLE_THREADS:BOOL=OFF
      -DLIBCXX_ENABLE_SHARED:BOOL=ON
      -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=#{OS.mac? ? "OFF" : "ON"}
      -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF
    ]

    with_env(
      CC:                 "wllvm",
      CXX:                "wllvm++",
      LLVM_COMPILER:      "clang",
      LLVM_COMPILER_PATH: llvm.opt_bin,
    ) do
      system "cmake", "-S", libcxx_src_dir"llvm", "-B", "libcxx_build", *libcxx_args
      system "cmake", "--build", "libcxx_build", "--target", "cxx"
      system "cmake", "--build", "libcxx_buildprojects", "--target", "install"
    end

    libcxx_libs = libcxx_install_dir.glob("lib{#{shared_library("*")},*.a}").reject(&:symlink?)
    libcxx_libs.each { |sl| system "extract-bc", sl }

    # Avoid building 32-bit runtime
    inreplace "CMakeLists.txt", "M32_SUPPORTED 1", "M32_SUPPORTED 0"

    # CMake options are documented at
    # https:github.comkleekleeblobv#{version}README-CMake.md
    args = %W[
      -DKLEE_RUNTIME_BUILD_TYPE=Release
      -DKLEE_LIBCXX_DIR=#{libcxx_install_dir}
      -DKLEE_LIBCXX_INCLUDE_DIR=#{libcxx_install_dir}includec++v1
      -DKLEE_LIBCXXABI_SRC_DIR=#{libcxx_src_dir}libcxxabi
      -DLLVM_CONFIG_BINARY=#{llvm.opt_bin}llvm-config
      -DM32_SUPPORTED=OFF
      -DENABLE_KLEE_ASSERTS=ON
      -DENABLE_KLEE_LIBCXX=ON
      -DENABLE_SOLVER_STP=ON
      -DENABLE_TCMALLOC=ON
      -DENABLE_SOLVER_Z3=ON
      -DENABLE_ZLIB=ON
      -DENABLE_DOCS=OFF
      -DENABLE_SYSTEM_TESTS=OFF
      -DENABLE_KLEE_EH_CXX=OFF
      -DENABLE_KLEE_UCLIBC=OFF
      -DENABLE_POSIX_RUNTIME=OFF
      -DENABLE_SOLVER_METASMT=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    venv = virtualenv_create(libexec"venv", "python3.12")
    venv.pip_install resource("tabulate")
    rewrite_shebang python_shebang_rewrite_info(venv.root"binpython"), *bin.children
  end

  # Test adapted from
  # http:klee.github.iotutorialstesting-function
  test do
    (testpath"get_sign.c").write <<~EOS
      #include "kleeklee.h"

      int get_sign(int x) {
        if (x == 0)
          return 0;
        if (x < 0)
          return -1;
        else
          return 1;
      }

      int main() {
        int a;
        klee_make_symbolic(&a, sizeof(a), "a");
        return get_sign(a);
      }
    EOS

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, "-I#{opt_include}", "-emit-llvm",
                    "-c", "-g", "-O0", "-Xclang", "-disable-O0-optnone",
                    testpath"get_sign.c"

    total_instructions = 33
    expected_output = <<~EOS
      KLEE: done: total instructions = #{total_instructions}
      KLEE: done: completed paths = 3
      KLEE: done: partially completed paths = 0
      KLEE: done: generated tests = 3
    EOS
    assert_match expected_output, shell_output("#{bin}klee get_sign.bc 2>&1")
    assert_predicate testpath"klee-out-0", :exist?

    assert_match "['get_sign.bc']", shell_output("#{bin}ktest-tool klee-lasttest000001.ktest")

    system ENV.cc, "-I#{opt_include}", "-L#{opt_lib}", "-lkleeRuntest", testpath"get_sign.c"
    with_env(KTEST_FILE: "klee-lasttest000001.ktest") do
      system ".a.out"
    end

    assert_match <<~EOS, shell_output("#{bin}klee-stats --print-columns='Instrs' --table-format=csv klee-out-0")
      Instrs
      #{total_instructions}
    EOS
  end
end