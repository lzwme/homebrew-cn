class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.0/llvm-project-23.1.0.src.tar.xz"
  sha256 "ab1f0e3ec52448c33e8782eaf0422504b87c7b016b22514653ee0d8fcee479ff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3ee8c0073e95ecc7cb476cf0e4eb2647834696d0dd1e38985519f137a949b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405b6f1e49b216b494f32039ac2001da55ee1dd0676581a370b7c3b6d19f0464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7dbf6aed2a4146ef7e74f5c6051bbd2cfbcabc28e124b323559d5e60db3e16a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d5474a0d2bd14c2e373dcec910417e8ff3893b685d4e1f671a3a0104c74ddbe"
    sha256 cellar: :any,                 arm64_linux:   "fb48f8de58ca5dfd77d452f16d758eb0796ad0a5796b23805c9a0dc5cc386e3d"
    sha256 cellar: :any,                 x86_64_linux:  "adfa85df9733e646a626c4710d03f5f38cd7330439ad5a5b235449b918baed1e"
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