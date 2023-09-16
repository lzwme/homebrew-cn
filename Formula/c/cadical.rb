class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://ghproxy.com/https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.7.3.tar.gz"
  sha256 "2b9564b98ecdbd5fdcbd9b987f638bf0c23734487db1e673f07a4d4452a6fc94"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd66d5d3aaaf55e867d435a9e90d74eec6c872556007191cda71d24772c594ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902b26155e7841d7e3e75b98dcf4dfd258c9b18a54586c9c44647d4129cc8b49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e8ee3f0848acf65e2f523fda08dafd2cc3a4ae3ed1b7b2a68c441f1960df54"
    sha256 cellar: :any_skip_relocation, ventura:        "ffd9ec9a44cd1e718a44111bf88c7506a40a2d6b0f3535fec1063aa0a4e7bc76"
    sha256 cellar: :any_skip_relocation, monterey:       "3cec4aa2daf3d0d9e87b5e84a3c739fe8ed18ee2ef57e819e9e6257da25cb3d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6426d6fc799cde8b086ed96b59435576e21249b7cc476f03575ee2faac7eead2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4821c54a176c6f574b261d3c341e26386b1dc256c01fd8dd89896762887c59a2"
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