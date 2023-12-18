class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https:fmv.jku.atcadical"
  url "https:github.comarminbierecadicalarchiverefstagsrel-1.9.2.tar.gz"
  sha256 "4aeb030ef5eb5e05c52e9b23cbba994551c219d49e8455189f60c34a5fe40da9"
  license "MIT"

  livecheck do
    url :stable
    regex(^rel[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d17e1dd4ece14fb58a8fe90240c0dc7eafe39a2ba3da4fea73ae7330889e2122"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dc2a7bef1bc539394d241c9a5b502f38f581529ce37e396b75c824485076b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efcb5fdd92f3eddecb97ea273fea368fc676e1d0f53cbe73708810bd8a1b05c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "151ccd0c077f8f7f8485536c8fcede881be0df90d78316b3f8fc007dcf57420d"
    sha256 cellar: :any_skip_relocation, ventura:        "b585d30d681fa62c1c262052bd48146a7633a5ec29b606ab76c88c467ab3b1e6"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b93984674967d12ab11aa14d7cf5385a38f3da09c87812230413d3f88d9ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56fb91aafebd20e5beb0d755483de0cd32897b3011d56a834100fecf4e2b666c"
  end

  def install
    system ".configure"
    chdir "build" do
      system "make"
      bin.install "cadical"
      lib.install "libcadical.a"
      include.install "..srccadical.hpp"
      include.install "..srcccadical.h"
      include.install "..srcipasir.h"
    end
  end

  test do
    (testpath"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}cadical simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath"test.cpp").write <<~EOS
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
    system ".test"
  end
end