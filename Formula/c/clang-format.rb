class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.3llvm-19.1.3.src.tar.xz"
    sha256 "11e166d0f291a53cfc6b9e58abd1d7954de32ebc37672987612d3b7075d88411"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.3clang-19.1.3.src.tar.xz"
      sha256 "0a0dd316931f2cac7090d2aa434b5d0c332fe19b801c6c94f109053b52b35cc1"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.3cmake-19.1.3.src.tar.xz"
      sha256 "4c55aa6e77fc0e8b759bca2c79ee4fd0ea8c7fab06eeea09310ae1e954a0af5e"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.3third-party-19.1.3.src.tar.xz"
      sha256 "ec13c6c3466dc88e7b29b47347e2b88337d5b83c778d92e3c4c3acd17d3cc534"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df6e7a73647777ea7d721611ff214cb6dfb0035270f7c075706c10126127fe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51c70ed59125cdc84a9e69c71519e0389302fa79ec69237daad87d56f880fef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "221b6502def9c8349e7b55503a925b7afad79e75edeaad2039d449156e31fe00"
    sha256 cellar: :any_skip_relocation, sonoma:        "387d602bb80b80d5e46d091bb620080d5734022b0512b42be0a0368416e40ff5"
    sha256 cellar: :any_skip_relocation, ventura:       "8609c73a51e4a27538fec7cf473da6a8808a273291c04df0f15959c134104048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f7cdba80030cd264f64d22fc3d5e0865c7167a0b2462a64bfe82d155e821c2"
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