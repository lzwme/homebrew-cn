class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https:c2rust.com"
  url "https:github.comimmunantc2rustarchiverefstagsv0.19.0.tar.gz"
  sha256 "912c28e5e289d1a9ef1e0f6c89db97eba19eda58625ca8bdc5b513fdb3c19ba4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91ba7bf44c954d674c4d17d5c4959347a4ecec307c89c467f86c2385993e9bd6"
    sha256 cellar: :any,                 arm64_ventura:  "df6a11535c68760e4cd319d282b791d0ac53e17508bc446cb38e74f16e581862"
    sha256 cellar: :any,                 arm64_monterey: "b153725d08d02ecf282b119fd23d9b5d8b8633719d84dae1da651babc78a6d27"
    sha256 cellar: :any,                 sonoma:         "089d4307655cbe4654cced9487e11f5cd023c462fafbf34af5ee28f1a8bd0933"
    sha256 cellar: :any,                 ventura:        "8a2ce457289df4ab8a952c5739fbb69eeac58bf23cfbe89ce8a7ed920c5be435"
    sha256 cellar: :any,                 monterey:       "46195003b9ddc8e715479cba427daa7e185a9b2cb88aec55a2323b3ee31c1277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "943361f3a32563316096e1367017503c30a6b7c5ccdb666038bbf35b45f6af95"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare"examplesqsort.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin"c2rust", "transpile", "buildcompile_commands.json"
    assert_predicate testpath"qsort.c", :exist?
  end
end