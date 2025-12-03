class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/llvm-21.1.7.src.tar.xz"
    sha256 "8657ee188b673a3285b991131abe905b4129a18d52d334f9d122463164ecd000"

    resource "clang" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/clang-21.1.7.src.tar.xz"
      sha256 "eeb5296f46eacc0a1fe6c47a1af9e8d4eb2a5da7254fd8dbc4fc1f1be74315a1"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/cmake-21.1.7.src.tar.xz"
      sha256 "f25ca011e4453ac035e940aa729d482d08eb83a91b4aaf1f230dc9ea28cadfa4"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.7/third-party-21.1.7.src.tar.xz"
      sha256 "5fe212feb27f325fa29530eb38e746a73d18205bf6a36d9800778a94108d2ee5"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fabb507e8eabd59ec12f5a3b1879e3014c5b166680f6c22ebd98814d649dd649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9d0baff6790013a363eabb000a94ae9562c247e4d0364ca70ee20b188e7a2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52c1881d00f096232f5286cfc84bacbb2ca44f977b532e0073151f48d52cbe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f42f7cb2edff4565a8ff4f724215e024f15ae5d8d16dbfb2b823a8fbdae916e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0704788c6f72c346d680d93886b09cc5e34b2046b6a561226c03a372a4180f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0a0aadce0197fe41d163d7c17d49e869cb00442c424eeda81367edc6f0da4f"
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