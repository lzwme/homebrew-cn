class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4llvm-19.1.4.src.tar.xz"
    sha256 "4fe1bc197ff13f33af6179f836ce1cf2ae9886b822974a736f3a20c8aed0c1b2"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4clang-19.1.4.src.tar.xz"
      sha256 "b6d123a4435f1869af709f3288c4c4db48173acaf621088400d91521bc5aa225"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4cmake-19.1.4.src.tar.xz"
      sha256 "dd13ce8eba6ece85cad567f028b8e16d72f3e142cdcbbd693ac23a88b4013803"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-19.1.4third-party-19.1.4.src.tar.xz"
      sha256 "97292083d9718d3a6bedbafddf2fa1740c2d9cba8c72ee8ea391a63f12c0a472"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24537717c66702cebaa7f941de4cc17ad8fa95e7ff1596bf94e8d33232da6b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02b7b95d14ea5645c34e8c82e396ad928a602d78c733204f6bbd4b75a26f4ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3f3ad055e04cf71831b122bb331941aa7ec580c3f0d07a7430e89ff524c923e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f12749e351600a8d4c9ab8a83e598f684d72ca43351ac9046a65da8c410ffc"
    sha256 cellar: :any_skip_relocation, ventura:       "10cc54d92bb66a6cebce8f584ee1f6a9ac820012251f85636b70423e677d2066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b130849e223aa183d7ff781dbf8a7ad3ed7930ec4550f34a7c8cdd656859e9a"
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