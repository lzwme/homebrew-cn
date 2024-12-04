class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5llvm-19.1.5.src.tar.xz"
    sha256 "7d71635948e4da1814ce8e15ec45399e4094a5442e86d352c96ded0f2b3171b6"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5clang-19.1.5.src.tar.xz"
      sha256 "e7dfc8050407b5cc564c1c1afe19517255c9229cccd886dbd5bac9b652828d85"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5cmake-19.1.5.src.tar.xz"
      sha256 "a08ae477571fd5e929c27d3d0d28c6168d58dd00b6354c2de3266ae0d86ad44f"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.5third-party-19.1.5.src.tar.xz"
      sha256 "22b352c35b034a4ab3f2b852b6a2602a4da8971abe459080450d9e3462550d1d"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe7789943f3ff52e1519a64e7d7096751d2ecd718d81e8f8537f23e6a0dca61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a57dd4ca69045608bec65e1d981ba888e6425ab26b79504be8e51747313710d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70087a7ca0f914888e27ef1f670673f8c13466f935b90e86badb07623ee99395"
    sha256 cellar: :any_skip_relocation, sonoma:        "b12ce9ba46de34c437ec2126ea301c8b59b5f79254d7bc148d620cca29f1973e"
    sha256 cellar: :any_skip_relocation, ventura:       "931e6c919d91fd2f5d13cb09c366f1e647656562a92a27188e32d3dc6a58f7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d95b5eff9f29eaef0eb6a759f2b62657e73ce70c8f79dc5d9594e585dbf8a0f"
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
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath"clang", buildpath"llvmtoolsclang"

      buildpath"llvm"
    else
      (buildpath"src").install buildpath.children
      (buildpath"srctoolsclang").install resource("clang")
      (buildpath"cmake").install resource("cmake")
      (buildpath"third-party").install resource("third-party")

      buildpath"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "buildbinclang-format"
    bin.install llvmpath"toolsclangtoolsclang-formatgit-clang-format"
    (share"clang").install llvmpath.glob("toolsclangtoolsclang-formatclang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end