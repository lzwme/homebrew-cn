class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://ghproxy.com/https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.7.2.tar.gz"
  sha256 "9e0f9deaf6379ab321f92e4ed5239a5577165eb29359ea7b425cc3204147a772"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82472cd46abacebbf696b9d152f8f3e82c9dc43c1215901253faa78966036129"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d742057d764937d2b4b52c413b1174ebc43aae3c22d58af6a23ddfba5068e2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e474b3bd21fe232b1b7501fb8ae11caf736632a2deadf345810881ba9755ff35"
    sha256 cellar: :any_skip_relocation, ventura:        "c1b1cded55e07c48536cbe910f64e8b6780b457627cd2cf5f6e357761066a085"
    sha256 cellar: :any_skip_relocation, monterey:       "35b41aa1fba0743d1c0161fa5ea180f9b8be9bb0a99fa5e9ab2272b07bef2412"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fcb7567231ce8f4676ae272e2773b3df8c73bb0f1b537cf053cea1bbf1ffe34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034d9f9761b105539256006935bc2d7406fb2afb2af76de6673bf9464eccfa27"
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