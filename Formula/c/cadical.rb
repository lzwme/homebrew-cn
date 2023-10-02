class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://ghproxy.com/https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.7.5.tar.gz"
  sha256 "1465c95d4d4f1e8f1d0c812af6d2e6ac0b509b43dc7fa125c74d2fe3152f3c25"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98ea2b5d23e82786fe7881da77ac9068c861d761f919321fae0504e97e1a5af6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8277cd158468696fedb569c7bd1f65a5233e818f89e53d35eeb5a91000672282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52a05f0cc3d64364965dea076083d5a78f0e206d43107b0df850d37e708874f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a777d37851bbf3233e3629e43c6e43ed7b8dbc79204962ccd7eab1d09a6c2410"
    sha256 cellar: :any_skip_relocation, ventura:        "f4ab3a8081dc367542e50e4e6243d6dd0b45c8a2582a273fd972907c7e7f2b77"
    sha256 cellar: :any_skip_relocation, monterey:       "5d0957e19d2bb58403191873cf7956f3d1107d425a4ed094e857cad1fdb93ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9cb04f314af3f89da7d9d264af06ab97bdbeead196cc8126fd8fec7f12fa692"
  end

  def install
    system "./configure"
    chdir "build" do
      system "make"
      bin.install "cadical"
      lib.install "libcadical.a"
      include.install "../src/cadical.hpp"
      include.install "../src/ccadical.h"
      include.install "../src/ipasir.h"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cadical simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.cpp").write <<~EOS
      #include <cadical.hpp>
      #include <cassert>
      int main() {
        CaDiCaL::Solver solver;
        solver.add(1);
        solver.add(0);
        int res = solver.solve();
        assert(res == 10);
        res = solver.val(1);
        assert(res > 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system "./test"
  end
end