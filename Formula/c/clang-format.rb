class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.6llvm-18.1.6.src.tar.xz"
    sha256 "c231d0a5445db2aafab855e052c247bdd9856ff9d7d9bffdd04e9f0bf8d5366f"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.6clang-18.1.6.src.tar.xz"
      sha256 "54e0817f918b90b5f94684e9729ac2f9d3820fce040d6395d71c1f19ffa3b03c"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.6cmake-18.1.6.src.tar.xz"
      sha256 "a643261ed98ff76ab10f1a7039291fa841c292435ba1cfe11e235c2231b95cdb"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.6third-party-18.1.6.src.tar.xz"
      sha256 "4ae7b394d341aea6fb7d3d373a4f561ba8e48c0fecded4bb4f1f5f12ba9bd2b6"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d433868eb4b12b5b3bd4bbb8f353436399208508cd4e43324f13ffe7aa8c066"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5216cbf84f70ec5f127a814ccf69755f85d5eeedc26ecf5c3d895cb89ccccbe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6efe750b37d6ea3197e4c40e8c1d5a512189f294a39cd3adf71e6677173dca"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bb47b49c5879c7f202b42c0fc17be8ed1c6199f2edec08aae6d5251a8e3b3ae"
    sha256 cellar: :any_skip_relocation, ventura:        "b54cdedc0e7b9c2bbce4b1cedb76eb5426104dcb52d0eea718bf44516920dee3"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3637cc736b76a3980ece33a900a7ae9f44e6e6880a497a4fd35aec3a768ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33695db85bf6b106dd1d5a7ffc7136d7199332da322a659c8e62fe06514439e3"
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