class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://ghfast.top/https://github.com/immunant/c2rust/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "4b39ae895f00b046878d5f312eec11c4b7d38d08b08e9de249a4eef938750229"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f55b4ef476ce58c11011535f5e5f98ea66accca078c0d103cb0733543cf7569"
    sha256 cellar: :any,                 arm64_sequoia: "a4c25aa436d370130b0c0a8dbb18919bd1dd12eee984681b245532b8c31ebb75"
    sha256 cellar: :any,                 arm64_sonoma:  "2f5fc229072c584fe2eddfca10ddfc9360c329793c9600b9e8bdbe84c0ac453e"
    sha256 cellar: :any,                 sonoma:        "cb681401b668d3b8209028129a8928fd7c19468b050b965a27edee786ddf3dba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e31c608e1729f18d4dfeeccce3fbe8ed25f230eec3f41e3f0c53d21921a6a5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b30f5226a1f86f2b9e0ed50a1612e976cadb6d11094be79dbe6aa60ffc7c40e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@19" # LLVM 20 hits https://github.com/immunant/c2rust/issues/1252

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_path_exists testpath/"qsort.c"
  end
end