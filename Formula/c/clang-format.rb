class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5llvm-20.1.5.src.tar.xz"
    sha256 "9a9a80ca4c0d902531f2b43e9e4d6c36b57cdd5702430e0b54567bf273bd32c1"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5clang-20.1.5.src.tar.xz"
      sha256 "97025772b25c6694db049d3c4be5a72d926299aa1a9b861f490d66750e31c9dd"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5cmake-20.1.5.src.tar.xz"
      sha256 "1b5abaa2686c6c0e1f394113d0b2e026ff3cb9e11b6a2294c4f3883f1b02c89c"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.5third-party-20.1.5.src.tar.xz"
      sha256 "8667f47185bee07f7c7988ead7161b0d9e41a1a01d5d7afd8f325c607641470c"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(llvmorg[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea669b1bfb5882ed0983327b2808ea0a9be3258e21e6c25ea6fb989521966fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e44a44ce9a155549523b34b37a7fab2bea7a711393f7874693fefa10ed29095"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cc18f4d3574af2dd57a91326db1025aaf6b141cd6d9b55999539ebbe94bdad0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4952d4eca5df3f7d37a5a397f6588b9bd88a282af5bdcfe097d7690720e6f9fc"
    sha256 cellar: :any_skip_relocation, ventura:       "04ade8931d414633ed449ad04e2e972ff1f0acf2881ead258425ffaca6481f7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70164ec17f614c57c393aaaf6641e87dc18cd185a0d3d8a8299e05df751fb57e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963701e8f374fb9669526ded749e8a6481cb73ab74f99f4eecb3e4cee42fbb61"
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