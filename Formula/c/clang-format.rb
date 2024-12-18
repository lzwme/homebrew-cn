class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6llvm-19.1.6.src.tar.xz"
    sha256 "ad1a3b125ff014ded290094088de40efb9193ce81a24278184230b7d401f8a3e"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6clang-19.1.6.src.tar.xz"
      sha256 "6358cbb3e14687ca2f3465c61cffc65589b448aaa912ec2c163ef9fc046e8a89"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6cmake-19.1.6.src.tar.xz"
      sha256 "9c7ec82d9a240dc2287b8de89d6881bb64ceea0dcd6ce133c34ef65bda22d99e"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.6third-party-19.1.6.src.tar.xz"
      sha256 "0e8048333bab2ba3607910e5d074259f08dccf00615778d03a2a55416718eb45"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3b1c576d39cae615a6bf558d416f53e9b8ba12e3e6675e325026fb7fb7ed096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc3444deac024d0d7364807c9505bb2a805c35c5b3c10a0a8c267a2b2321606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f10999f36ee6067a08723893cafcd984b7c63aaba2533a68a46a23ce3bbf08dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9bebcbacc13d46993071e698af4f760f59b06185c8ae0f29b9ea9e6a63a092"
    sha256 cellar: :any_skip_relocation, ventura:       "d42951b1941e5edb02ea1f15d0f070e90e1819e1e6cc75d892fe0746a24a4d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cf162378530d55dd7f17a247981f6c7badc6334f3a51da7849fdc3fe36ec78"
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