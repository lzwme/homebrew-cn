class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.0llvm-18.1.0.src.tar.xz"
    sha256 "b83af9ed31e69852bb5f835b597f8e769a0707aea89a3097d4fc8e71e43f2a1a"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.0clang-18.1.0.src.tar.xz"
      sha256 "c5cb0cedec2817914e66bb86ea4c6588ddf53b183e89b2997741d005f9553cbe"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.0cmake-18.1.0.src.tar.xz"
      sha256 "d367bf77a3707805168b0a7a7657c8571207fcae29c5890312642ee42b76c967"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.0third-party-18.1.0.src.tar.xz"
      sha256 "5028eb1d6baa7b59cc88b2180467ea67ff2d5d4acdf095b530260d9d8868c16b"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05e3f70c17dd15b0b0016a663b89b3a509743f862784a0a398f55c4589abdc5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a46a912c96c0bfba20211e9324cadb8e7abbcbf76fac674527c2fd18e1c33e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa1c3ad87fec6bef55c71a846a6fc7de27ba2b8996462cc8632d1fc66e28841"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0a9cc4e43b7acd203cb243d5f648b81ec3f6b201fb9e07c1277836ddf0ecf12"
    sha256 cellar: :any_skip_relocation, ventura:        "7727f4321eb2bccd03fdb2976085d4a472537d5b63995dc43c84a7170027a355"
    sha256 cellar: :any_skip_relocation, monterey:       "b0fb6ebfbbf0dfcf5f11b3b40b0c39afc88bc0645b8a41dc7e16d7e1adcf712f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7966e4973e180fdbe1fd8cb397febf271bd77b795f8a26c1b26bf1d7678faef"
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