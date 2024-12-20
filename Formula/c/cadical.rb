class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https:fmv.jku.atcadical"
  url "https:github.comarminbierecadicalarchiverefstagsrel-2.1.1.tar.gz"
  sha256 "6e6ad07dc833d2ae4f49115f9b92b5f78e4b1a9ef37f83f252dbc035c9d41850"
  license "MIT"

  livecheck do
    url :stable
    regex(^rel[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcda9767eeeb92ee295e5ea771685921675abe36cd05fced553c42dee2ee42e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eaa2bba5167b6886cc22cde377134970373454b8726b119567a3c1640e3e2d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "051ee3a2b14fd87fdb4677ff19c936a08b7a24ef35b0b240cd5f7419082f5822"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf1bba0754b2f75845bee0419c7a31b2f5b0c7b7513e87ce27b39822bc14e361"
    sha256 cellar: :any_skip_relocation, ventura:       "9a4ca7ff7f647a65ff10c1cc21a765847fb23fba46f58890b09b789ea0579895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd1ec6e2fd2f692e59cf687715c14d4c3b2c1853a6e345491c93392364403b7"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?

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

    (testpath"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcadical", "-o", "test", "-std=c++11"
    system ".test"
  end
end