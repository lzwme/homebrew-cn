class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/llvm-project-22.1.0.src.tar.xz"
  sha256 "25d2e2adc4356d758405dd885fcfd6447bce82a90eb78b6b87ce0934bd077173"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3927b91e36ce8733514f11724dd53e08dec7f174f6eaa3452aceeb510e95f9e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ffc928625d715fa8040c12dab444784b5308b28fc2e70f10df44869c730dd48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617036a81389380d114834171ee653a1554cf6500e71a753d4eec1e2f71d06f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "93adcbc5f4b845e66cd724239111c679226e9b8de71757da9f4f2a708b98813b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6e32603c3123e4674b4fe75aa706c97be5c3491751e2499ec7e32aacd76e988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3dab00459beb4c81b0593c969bad7a18ddf8a2d51a7e9f404847abb639b3260"
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