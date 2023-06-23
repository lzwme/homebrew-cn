class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "http://fmv.jku.at/cadical/"
  url "https://ghproxy.com/https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.5.6.tar.gz"
  sha256 "a8daffa946b849357fc05be15ee567add2a472f1a0eea45968b4c602ba99fd7a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "112fce553fcaee3406ec663bd2ab8a92afcd74f1f26ff6ea7ec66fb3f0d7c09d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a46ea9671c1b1959ad46ce356dd7942a9944f774dc00f59b758f067a2c18448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b60818f5a3a2f171dd29ceae12fad7fcb17ab8b74f6fbad5ceb6b9a96de64f2e"
    sha256 cellar: :any_skip_relocation, ventura:        "1af254f4d3e7fa442335d24f069c722679e92d3a8e7c90e526dcc3001d514098"
    sha256 cellar: :any_skip_relocation, monterey:       "c46bd6ef08e675ba6836b067c8640a28af075f3716fa2045676ce798acda89c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c4397768a929acade255fe85018edb526be951edff47a8da430bca5d0338ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f293a170951b1c5620e255d58221d704a99a978be65a34114a505b9d272458fe"
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