class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/llvm-21.1.3.src.tar.xz"
    sha256 "a80f2dbfa24a0c4d81089e6245936dcd0c662c90f643d1706bb44e7bc8338ff1"

    resource "clang" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/clang-21.1.3.src.tar.xz"
      sha256 "a70518c2d4c90b8b170732e1342a9854ec2babc310b41d5556a83f4b55a63d1d"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/cmake-21.1.3.src.tar.xz"
      sha256 "4db6f028b6fe360f0aeae6e921b2bd2613400364985450a6d3e6749b74bf733a"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://ghfast.top/https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.3/third-party-21.1.3.src.tar.xz"
      sha256 "2bae76a7c7db4096b921589ae94c030727ee0dcb600bfe40353878937af61aa0"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a44f2dbf8165944ad0c6545329af5bc782feeec82e2e7240ce7bda814a4714da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c4bdc00f55d3a5268718990ea70224fcfa9a3bdba2c2c2bf17248d6af1e690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c82c553fa450645641ab6496c3b6c82bb15c25b12c968550aee4fa7af525eece"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf25229d5048e12e0932cb0b11d449f35e4e9473640930f431a99c048aefab2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c23eeeddc65ad4093ebc62caadac808ae54ca3a2cd964abecac9d2799f641c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d18713cddbc537583ba11a6e0337b6bc3a4b4546b50d640035f91f746197680"
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