class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https:github.comllvmllvm-project.git", branch: "main"

  stable do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.1llvm-20.1.1.src.tar.xz"
    sha256 "3e9a489726ac21664331bf7e2b719ab125456bfda365095542293c9ac9beb3dd"

    resource "clang" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.1clang-20.1.1.src.tar.xz"
      sha256 "7d4e838cfd97a6322df376a9e54889afc4bae4e7bb7636b452f5816e5c71dc8b"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.1cmake-20.1.1.src.tar.xz"
      sha256 "b5988c9e3df3a61249fa82db54061f733756e74f73dfb299ff6314873a732d61"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-20.1.1third-party-20.1.1.src.tar.xz"
      sha256 "0ed3a78dedb0e6591e1f9541d6a2e684a44886d6811d49f3a14ddb53569f79a5"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32d2f3d50690d432248b458c9142b63312032f7ee84514cc21fb693da5a9113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ccca6c2aaea833e547bf8f109c4fc2ddfada8216cfd57ddddaf0ee92220afbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c383716f982b5474031800351f6c98d44af9a6370f771413f150deb729a2e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "360a241eaf46220d55fd97b6b3e5a99f33aecaaf846eb10c0d050fecbb47b513"
    sha256 cellar: :any_skip_relocation, ventura:       "45defdef237af17a06f56528bc863a36045bcb916c6dcbc9feb33b1f69586349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ede98bbacac4268e61021104cf1e85282621bf4bc830d1eeca553bd70ecea19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8fc7a3c4c8415560f14ef332035a012408eef49f923884ced51f04250bb6db"
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