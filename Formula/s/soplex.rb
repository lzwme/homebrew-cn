class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-7.1.6.0.tgz"
  sha256 "4fbae2d1f06ed2204c9e37b5775f04dc05796f7ac900977e19bcbdbfeae9bf56"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1550aa55004abebea063bef5299a9aa415f2a6e6b675f52ae0f3e8bc924fb3fc"
    sha256 cellar: :any,                 arm64_sequoia: "66f9a48f8ab8c3148af4ab89df677159fa55b5e982bdb9485b09a97f37998096"
    sha256 cellar: :any,                 arm64_sonoma:  "3818410f86d164251f21e54798e36a59bd65e0bb8ea6f6f409a4e9ea13df031d"
    sha256 cellar: :any,                 sonoma:        "e2932f376cf82fa64f47e7062ee7d3de492c6621a61d99d7f6f110506a958a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e53bc419de2813f3badde9e245d01026c8f37570263fba9ea759a7514bb385e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd747f830bfd203330a6f440512213c4f5c866054c1c74bd457302f1f91fe09"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "tbb"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "src/example.cpp"
  end

  test do
    (testpath/"test.lp").write <<~EOS
      Maximize
       obj: x1 + 2 x2 + 3 x3 + x4
      Subject To
       c1: - x1 + x2 + x3 + 10 x4 <= 20
       c2: x1 - 3 x2 + x3 <= 30
       c3: x2 - 3.5 x4 = 0
      Bounds
       0 <= x1 <= 40
       2 <= x4 <= 3
      General
       x4
      End
    EOS
    assert_match "problem is solved [optimal]", shell_output("#{bin}/soplex test.lp")

    system ENV.cxx, pkgshare/"example.cpp", "-std=c++14", "-L#{lib}", "-I#{include}",
      "-L#{Formula["gmp"].opt_lib}", "-lsoplex", "-lz", "-lgmp", "-o", "test"
    system "./test"
  end
end