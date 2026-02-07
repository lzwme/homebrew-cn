class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://ghfast.top/https://github.com/immunant/c2rust/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "c9c8a36332e8bcde0bb9739cec02bd5263c5b25b7300428d8c6a8af094160d98"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9324f14c27a2c6bb08fe3e24aaf93a2619a16b2667df0f2bb74fc2bbee08dc69"
    sha256 cellar: :any,                 arm64_sequoia: "b939f948aa97dc10c1751525527d1345713ac2ac36f3bfb22160275af1dc3444"
    sha256 cellar: :any,                 arm64_sonoma:  "ab9cfdc46db079912e513077fbb5475284eeb9e5fda0217d3abf32a763d94dcf"
    sha256 cellar: :any,                 sonoma:        "11ef3e3b68889f73364b17e40501e243849565a61cb3a0786492c22535137a16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03dbb02e1782dd51dbab9553d9ae880bbbfb6216d61e249d6a919e2138b9a009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d6791d88d3b461b9e19a4601bd19717286174c0a1b45688acc87c8d8318b3a1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

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