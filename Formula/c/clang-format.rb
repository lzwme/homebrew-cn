class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.0llvm-19.1.0.src.tar.xz"
    sha256 "a8b141cbfa13f50d84ce545899bd311aaa60d59dfbf7f3a0cf84f25badc1544d"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.0clang-19.1.0.src.tar.xz"
      sha256 "03c3be44ff8e602213222fb99645c239965623d2bf2a6e4d210249520112377e"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.0cmake-19.1.0.src.tar.xz"
      sha256 "dc78b6a9ac8a097ca6ac0f23c06821d65e6ea3bf666026f529994c1d01056ae7"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.0third-party-19.1.0.src.tar.xz"
      sha256 "f521e6cdb6598d777c6120d086aee3993f182ab38bc59ce4a59c48fae4839b8c"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9f55ce1e7070804eedd3714d6bdcc51d603d5a485dc9bae070e8c61a40c7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7430daa8b4ed88ad80c6224a1529d9ca11a192bcc24f9056be4b0797256592ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd47348ac5d1243cde53a6572bde91b4adde18ddfcc86df8e063d969305ad5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8db8fe084ab3090cdd83241f325de36549e4404382b4f79f624e41fe5209c136"
    sha256 cellar: :any_skip_relocation, ventura:       "02ddcb526b715cb480296f2d7a930afc092e3fc44f1e966a03683ea5f595a1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59a311e84edc3575c055df2e48f95ba4a81709563151979d60786f3da9f40c4"
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
    (testpath"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end