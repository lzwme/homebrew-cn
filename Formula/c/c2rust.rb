class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https:c2rust.com"
  url "https:github.comimmunantc2rustarchiverefstagsv0.20.0.tar.gz"
  sha256 "482330d3f27cfe85deea207e490bebbbe9c709b4bc054e3135498b3bbb585bec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dacd5b36647696ad2e1863cb2f12fa8c6063c242f691d371b808a1b0310f0911"
    sha256 cellar: :any,                 arm64_sonoma:  "b97d3c3bfc6ef351f11d6c354429883673846f68fd5f4358b8f6d6bbf57355c0"
    sha256 cellar: :any,                 arm64_ventura: "0b0a702e795b476ee814afb2baae0ada272969df641eeb73de82ca4c730688fa"
    sha256 cellar: :any,                 sonoma:        "77ed97b9636ca5992fa5b445d951976d696c2d4aa50e321d60d046601ecf832f"
    sha256 cellar: :any,                 ventura:       "dea354ab6e4c104f14001b5005589ffbfc617e7c3af9c52b8333016edf6236ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fffe661d012d1c8957c55d107c6c85438f2a3c8199d2d298744ad5964626da33"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare"examplesqsort.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin"c2rust", "transpile", "buildcompile_commands.json"
    assert_path_exists testpath"qsort.c"
  end
end