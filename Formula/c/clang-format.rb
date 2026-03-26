class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.2/llvm-project-22.1.2.src.tar.xz"
  sha256 "62f2f13ff25b1bb28ea507888e858212d19aafb65e8e72b4a65ee0629ec4ae0c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e4f6f3804dcbb6144f49f6178c939b4f02cd1d6dd69994fb2e5f01235c83d8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39768eecc81a257c1cebc4555b59e80682fc789c648ab767af5c0742694e5942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e95f56057bdda0add9a0e169b6214f267bc366280e2fda8fdefd763006bc377"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff5813e46d92c8e44719ffe99fa50fe7eb4b8c4ad61fb881c63be2d8175df34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce922ac31f26d18a332d9c2a54ed95490c641025978762e370dc99ee39d2818d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ca58dd46b84cefe5d54a6ba6d6501e4b8d87381048d94e0374db2a96786e52"
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