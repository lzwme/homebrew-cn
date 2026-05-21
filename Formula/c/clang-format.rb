class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.6/llvm-project-22.1.6.src.tar.xz"
  sha256 "6e0b376a1f6d9873e7dfb09ae6e04b9c7024400f01733fa4c29be69d5c138bc2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f035b579c031ed5f2d1052f50afae5bd8abeb72926192d38a386259fa2b691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c7110a1be766abaf47ce02622249c495006623cbdde55407349fc3cc254c766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e616b2df72d7d9ab4e7abd4389e9aafbc26a1da23cea004f1302f8651dac580"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ac581a1dd773fa8f0822f4df94845250fc0f546651cce61a6830f6eec3e8eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47bf0913c04bf3725b1e7562a511240b6457b74a54197ffd2774cccd9b57b299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc61c77b6d18963078e43fa3f07832620c709ac54e44ffa0d7f4e1f17ddc075"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

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