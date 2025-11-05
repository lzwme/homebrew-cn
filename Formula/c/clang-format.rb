class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/llvm-21.1.5.src.tar.xz"
    sha256 "c9d6ca5073255192850471a276b3a00a6555c6dd09df6cb3eab77801f0a1cae0"

    resource "clang" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/clang-21.1.5.src.tar.xz"
      sha256 "eee4de3b3f01ea6dd6b0936ac8be319eef0a65d0022def258c70110e3743807c"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/cmake-21.1.5.src.tar.xz"
      sha256 "48013d5714a96419bf993a2e5e4c5827377e8cf9c565070731fb2305d50d9511"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.5/third-party-21.1.5.src.tar.xz"
      sha256 "4ccc00ec2e7bd0cc121eaa34fa25a0480bfb8a5722faf1694720e0be99b753e6"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ba9a5248830b4f0ae5826b72817d3856742e747c129e3d87212a3bbc10f4765"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5015d5ed204d6ce1476250ac2e320b9c1fd6bc7ec18d5bc0ccebaa1808c4a0c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1ea4471139715bd24eeecd14d217aa7ff3b473af8872f1c05219e5bc47c43a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1b2bcce8f182825860dca57c0efc859ec2bd2f049280dd22e4443239ce90877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6765ebbad06995cea97f46efe0568b9ab52a8bb125a608ed8e5a2569f53e5fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f6eb4e7a881a4e46542c060f7592c857e5b923d7445751c5bf057b594d8564"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

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