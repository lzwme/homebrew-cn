class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/llvm-17.0.6.src.tar.xz"
    sha256 "b638167da139126ca11917b6880207cc6e8f9d1cbb1a48d87d017f697ef78188"

    resource "clang" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/clang-17.0.6.src.tar.xz"
      sha256 "a78f668a726ae1d3d9a7179996d97b12b90fb76ab9442a43110b972ff7ad9029"
    end

    resource "cmake" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/cmake-17.0.6.src.tar.xz"
      sha256 "807f069c54dc20cb47b21c1f6acafdd9c649f3ae015609040d6182cab01140f4"
    end

    resource "third-party" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/third-party-17.0.6.src.tar.xz"
      sha256 "3054d0a9c9375dab1a4539cc2cc45ab340341c5d71475f9599ba7752e222947b"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bb881df31b9f0dd6a85ef97572b31bf8292aa7d05d8f35d49bc830424b3011b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7835985d5e6edfb05205883c484135120789c78bc3b5eeeddc39d7b5170c6b16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67fbefb432b2cc11d08c14ffb89cb71b1026a83b81c2e7fac089663a053b64c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e11bb2ee8e4012e08afeb1c2109af21feba56e7225ff6e473e69c8ad2aed36ea"
    sha256 cellar: :any_skip_relocation, ventura:        "fcb5fe00f5fca01bbe9aae794a6d4c3459effce8f9906445f44d2991fece69ae"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea4441a6fc772efe6eed7a3e64ca74229753eb2b0d66f5b81ead8eed3ae973e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e9c5cc360ace20a6eaa5ee6c1956ba93e32faf67834e4c931f60277f590724"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end