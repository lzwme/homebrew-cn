class ClangFormatAT11 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https:clang.llvm.orgdocsClangFormat.html"
  url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-11.1.0llvm-11.1.0.src.tar.xz"
  sha256 "ce8508e318a01a63d4e8b3090ab2ded3c598a50258cc49e2625b9120d4c03ea5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d680a9a2a892531dfd38de0cd43dee55268a7eafea7ab72f21b00f06705a04fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1948c72aaec14b99817bf4fff1b6e07172f57975318a0b570c01f35be45cdd98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04eb4f41a69b4e4f1c3d4b020cfcafe07556fec0ce45bc2ffb1ad858e8ce389c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08840589ede996c8040c994dbf2fd257892fbab226721bd4212f759bb88ecf08"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed31b4214f10d7c730040ef07fba68c7eb2cf99ff6e8118feda8c02114c16fa2"
    sha256 cellar: :any_skip_relocation, ventura:        "155903a7ad58a6f720625d6690e892003c3e8b743df77a9f24d2007df207e48f"
    sha256 cellar: :any_skip_relocation, monterey:       "e59f3acdd1ccb01100c1e22093b61c5d442b3eb290857e9226ace3e070376b20"
    sha256 cellar: :any_skip_relocation, big_sur:        "d05a3e8c962d0170d27dd1cba184cd9fc7fabad7792e60402dc530c1849b33f6"
    sha256 cellar: :any_skip_relocation, catalina:       "34600b6ed222dfaa3ad410e6abbbc2ec86da0cc8f6906156d443665f57472db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd67883368c8948f35545a2bce2356f8af91f1c518b17e5e41fc95d286dc9a00"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "clang" do
    url "https:github.comllvmllvm-projectreleasesdownloadllvmorg-11.1.0clang-11.1.0.src.tar.xz"
    sha256 "0a8288f065d1f57cb6d96da4d2965cbea32edc572aa972e466e954d17148558b"
  end

  def install
    (buildpath"toolsclang").install resource("clang")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install buildpath"buildbinclang-format" => "clang-format-11"
    bin.install buildpath"toolsclangtoolsclang-formatgit-clang-format" => "git-clang-format-11"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}clang-format-11 -style=Google test.c")
  end
end