class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/llvm-15.0.7.src.tar.xz"
    sha256 "4ad8b2cc8003c86d0078d15d987d84e3a739f24aae9033865c027abae93ee7a4"

    resource "clang" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/clang-15.0.7.src.tar.xz"
      sha256 "a6b673ef15377fb46062d164e8ddc4d05c348ff8968f015f7f4af03f51000067"
    end

    resource "cmake" do
      url "https://ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/cmake-15.0.7.src.tar.xz"
      sha256 "8986f29b634fdaa9862eedda78513969fe9788301c9f2d938f4c10a3e7a3e7ea"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f272332a2b75d4b2e6a51d4832a848a598b923b4c6dc14568f004ec1f8fda6a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc12db5146de47d0073253d8f2403dd89977901b1b43900592807849bdbbce4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bafecdcd368ae3efafef3ccfc94af76c0a6af5978c082cd883d40e7a98779c4"
    sha256 cellar: :any_skip_relocation, ventura:        "86374598d776c1bff7b7d4a629cf7a498f234015a26a8c17878023e701ab3ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "a05743c7c240393d43f146fd2e6e61a1d3e5d79723eb73c6aba550d785fdc8eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e98e7315aaaea570c1b754ce8830b6ef914f9da4adb989adacaa8e3d2736248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0e6e2b1d5bc61e7da4c34ec6a4ca7c0caae691b53a175f095f72dc1efe6318c"
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