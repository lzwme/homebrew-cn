class Lldb < Formula
  desc "Next generation, high-performance debugger"
  homepage "https://lldb.llvm.org/"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.2/llvm-project-23.1.2.src.tar.xz"
    sha256 "c98bbef08a2b4c2613cd50e9aa9ae7b69b1fe6c16b2c40373bc0ab6116fdf78a"

    # Fix build with macOS 27 SDK, which defines `CPU_SUBTYPE_ARM64E_X1`
    patch do
      url "https://github.com/llvm/llvm-project/commit/923902483c7a6937a65b9679795a247ae2a2ad56.patch?full_index=1"
      sha256 "779ad57084a91143c84907ea83f41925a1d08b396a08551c08ce39e7d35a0f07"
      type :backport
      resolves "https://github.com/llvm/llvm-project/pull/223090"
    end
  end

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 arm64_golden_gate: "979c03ae07b85b9bd80c43671fe758e01faf10f63d26e9e348c9a19908e9fb4d"
    sha256 arm64_tahoe:       "39d4418e0f570065523c3ab25d2a08426354a74a9196a0ee6e78e1702262071e"
    sha256 arm64_sequoia:     "64ed799abc98a5bca35bc4d113d62d860448c0ce31e3bea131db4e362fadf0b5"
    sha256 arm64_linux:       "8210d267d7f869a79eaecdd5da1bee004e57f1167dcebcac715bf89142e45ced"
    sha256 x86_64_linux:      "8d94954bcaf0d454fe476b2061963f42d8dc46ce13636f50e35b510b675668b3"
  end

  keg_only :provided_by_macos

  # https://lldb.llvm.org/resources/build.html
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "llvm"
  depends_on "python@3.14"
  depends_on "xz"
  depends_on "z3" # TODO: remove in LLVM 24
  depends_on "zstd"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    cause "linking fails with undefined references"
  end

  def install
    # Features are set ON/OFF to avoid auto-detection impacting reproducibility.
    # See https://lldb.llvm.org/resources/build.html#optional-dependencies
    args = %W[
      -DLLDB_ENABLE_CURSES=ON
      -DLLDB_ENABLE_LIBEDIT=ON
      -DLLDB_ENABLE_LIBXML2=ON
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=ON
      -DLLDB_ENABLE_PYTHON=ON
      -DLLDB_ENABLE_TREESITTER=OFF
      -DLLDB_INCLUDE_TESTS=OFF
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLVM_BUILD_UTILS=ON
      -DLLVM_DIR=#{formula_opt_lib(name.sub("lldb", "llvm"))}/cmake/llvm
      -DLLVM_ENABLE_LTO=ON
    ]

    system "cmake", "-S", "lldb", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Check that lldb can use Python
    lldb_script_interpreter_info = JSON.parse(shell_output("#{bin}/lldb --print-script-interpreter-info"))
    assert_equal "python", lldb_script_interpreter_info["language"]
    python_test_cmd = "import pathlib, sys; print(pathlib.Path(sys.prefix).resolve())"
    assert_match shell_output("#{python3} -c '#{python_test_cmd}'"),
                 pipe_output(bin/"lldb", <<~EOS)
                   script
                   #{python_test_cmd}
                 EOS
  end
end