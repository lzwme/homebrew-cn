class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.3/llvm-project-23.1.3.src.tar.xz"
  sha256 "c44186a7762ed28954be72e5ff6df9808e0779d4f1bf014ecc4e7e211d31ee34"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d46320d2568b65201a4313eb56c25b550d8ee872b94115ebac6455d47d0157ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7da1a4a0b29562d0205bb45aa466ff829f72362ef1c680b1660b2275ff5d7c2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55785d49e2da4b609f3e696c7ad6013eb22f77cbefe5acd228e0fd517babe089"
    sha256 cellar: :any,                 arm64_linux:       "5520907d27cb47da89ea03ee780e8cf8298569539c9fce308a0ea91aa397c98d"
    sha256 cellar: :any,                 x86_64_linux:      "4184af742e2d951bd7264fa2f44ff0c6780629dffc51588bde85e25d53d0f977"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  deny_network_access!

  def install
    system "cmake", "-S", "llvm", "-B", "build",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"
    system "cmake", "--install", "build", "--component", "clang-format"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal <<~C, shell_output("#{bin}/clang-format -style=Google test.c")
      int main(char* args) { printf("hello"); }
    C

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end