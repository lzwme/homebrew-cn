class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/llvm-21.1.4.src.tar.xz"
    sha256 "f311681255deb37f74bbf950a653e9434e7d8383a7b46a603a323c46cd4bf50e"

    resource "clang" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/clang-21.1.4.src.tar.xz"
      sha256 "3e8e25a7478bfb0ef510fff35d1a43bdfb62c7727bf98bb43ad33deef2f9f1a2"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/cmake-21.1.4.src.tar.xz"
      sha256 "f4316d84a862ba3023ca1d26bd9c6a995516b4fa028b6fb329d22e24cc6d235e"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/third-party-21.1.4.src.tar.xz"
      sha256 "ae8658390504e08e464f65ecea838a0584df4734c27cecedfe7eb32780e81564"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37df0c0aec8f1a2f96e0311f6aa6251277330e1568461d0a5e1f41a7ef40001d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325f14dd512b59904546e8615c7cae7be7d6d9dfffea8d2ea851803db449a09d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4937402865c0d46a20b7e86163177172fe706aac1dc656637304b78d71750d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3d844ccec85597fd7ea6e568a04f1de1b23a672dc763b44becb33ed8151be4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4657db19c40a95ea5882ec563665fbd1f5441991fc6a605595f2203a1afd37f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ddb52f5feaf125981fbf9a65d890633016e862e716d6f390e8c7129c4c880a5"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python"
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

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
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char* args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end