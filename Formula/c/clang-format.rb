class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.3llvm-18.1.3.src.tar.xz"
    sha256 "fa6db8951f5ef576ac6bad43d5e1ed83962754538c998fbfa0397cd4521abc00"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.3clang-18.1.3.src.tar.xz"
      sha256 "e43e1729713ac0241aa026fa2f98bb54e74a196a6fed60ab4819134a428eb6d8"
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.3cmake-18.1.3.src.tar.xz"
      sha256 "acfecb615d41c5b1a0a31e15324994ca06f7a3f37d8958d719b20de0d217b71b"
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-18.1.3third-party-18.1.3.src.tar.xz"
      sha256 "ba1de46e740133d361c0d5d1387befa309f0b60f81bc2bf003252bebdcf9eada"
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c74208e93bc370f24676d9c80012b33f61bf9a42759e11e772e5991da324f610"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56051c43cf88d4d7e307b80f4011ee842d7cbd84cc521a89373e40f3d4ff8746"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1524fda32ac0589793cc502d767e5ed59896da60fef1839277d0b27716f83d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "620268f7c87f19699f0a1ccf398258f73e7fde7e4742fa24633a50e58a9ec5ff"
    sha256 cellar: :any_skip_relocation, ventura:        "59fa3e32f1ff251c25fac685c5085a54bc090d50893291aaa2f533575d42f579"
    sha256 cellar: :any_skip_relocation, monterey:       "6b8a791b45c7e5c940edcc3e105454a9108e2fc77b1caf0a7fb6137e13e5e8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0def54515afa83387c5881af5c8ac37f291c254e4b8a29e6b65d315b505c75b"
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