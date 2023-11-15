class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/llvm-17.0.5.src.tar.xz"
    sha256 "569526fd017478eee51518a79c064442c0499269c6a6de586e409d91282afd04"

    resource "clang" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/clang-17.0.5.src.tar.xz"
      sha256 "66b45502b9d570fda7feefe3595e34f0bf0c49df84f4298c7735289427f17bcb"
    end

    resource "cmake" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/cmake-17.0.5.src.tar.xz"
      sha256 "734ea7767ebda642d22c878024c9fb14ae0521d048bdba54e463bb73260adaef"
    end

    resource "third-party" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.5/third-party-17.0.5.src.tar.xz"
      sha256 "fe2f67bda7b1c28ff3930a91481cf64b6059aacf7b683c29b95424d32a258890"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc354faee1cfeee4d0218d9365d6fb1eaf5343c56e8c4821ee4ed315c909d17c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8d170ab94b7a2752558876caf673785616a81d4473de15ab38add1f12e8401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4df32c5922921e66c0060d45e52f0040e931e6b501e537466373961b9b8870d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e8ff161bb7b0ac2e9fe2fc41301393d596bc697b91aa244d4f7bbe2e503391d"
    sha256 cellar: :any_skip_relocation, ventura:        "fdcae974413601a1336aea52c76b86d3d1c586a43cc21ea6d578c7f741af651c"
    sha256 cellar: :any_skip_relocation, monterey:       "9df43f701c347956826700b9d0e833d6ac1adca1e4acc8cf1fa0a3db8ae4e59c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0324b477ba6a61e74f2878e06fd8a61c1fa45f4bd60f03d81dd7346bb2997ba"
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