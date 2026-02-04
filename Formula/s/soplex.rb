class Soplex < Formula
  desc "Optimization package for solving linear programming problems (LPs)"
  homepage "https://soplex.zib.de/"
  url "https://soplex.zib.de/download/release/soplex-8.0.1.tgz"
  sha256 "f833af9046d33c51de653effee38cca1fe99ba84a2ffa243eecdd8a5f22998e2"
  license "Apache-2.0"

  livecheck do
    url "https://soplex.zib.de/soplexdata.js"
    regex(/["']name["']:\s*?["']soplex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "727c7c47c4156e0c67c6a154be58baa7cdc4c05b86738cdae413df1735e34ac3"
    sha256 cellar: :any,                 arm64_sequoia: "5c3d180e504f68f0c01550830642b1d0ce661b31e0c19bca1db3eecb7b5b323f"
    sha256 cellar: :any,                 arm64_sonoma:  "b19e58a699a0849efca6c1c740a8469a65d41a0ca03b0926aa5c062a9167bd61"
    sha256 cellar: :any,                 sonoma:        "c49e509a0f4052de3a45b2ef266fd4667cba3a1174c1b983a6830bf8b0ccf3f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5607efa770fcc6c38d7e6058f06fcdd3e17a5af9f8b36e246219a2f0aed3c452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b92c6ae4732d9d9e1d1eb51a2b9a2bed8939424198de66e29bd1aba14e2e936"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "mpfr"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DPAPILO=OFF", *std_cmake_args
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
    assert_match "problem is solved [optimal]",
      shell_output("#{bin}/soplex test.lp")
    assert_match "problem is solved [optimal]",
      shell_output("#{bin}/soplex test.lp -f0 -o0 --readmode=1 --solvemode=2")

    system ENV.cxx, pkgshare/"example.cpp", "-std=c++14", "-L#{lib}", "-I#{include}",
      "-L#{Formula["gmp"].opt_lib}", "-L#{Formula["mpfr"].opt_lib}",
      "-lsoplex", "-lz", "-lgmp", "-lmpfr", "-o", "test"
    system "./test"
  end
end