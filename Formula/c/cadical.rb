class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://ghproxy.com/https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.9.1.tar.gz"
  sha256 "32652086c145209ce683c977b0c1a194b2dc30aa36572cfdb973c2f4894d05b2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2e83b4df0f249a8548f54f3d28cf2752bc1c7f9bd7262193b3a3e660b39970d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2ea850c4fb3f499834cc9d5ffdad13e0bc379f2b32a966cc65e421f5938f922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75fae454f3c57c889991c031b5e8766af4eefc0b8f8b65463cd44541c808adf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "07250b0daac89adddeb2eddca58231d2827511eb8289a81310da378203f29151"
    sha256 cellar: :any_skip_relocation, ventura:        "a610db7f03b1227fe10c256548cf0a78f4587c3c8aed29f2d369d21e0559a79b"
    sha256 cellar: :any_skip_relocation, monterey:       "9cdf58d44abe66568e32574c0842039d42f77f812077f746f24f50f7a7c7fa94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89406a2c4a438a96b8efbbbd21c2fff9cac73f02533e9c4e46270976fa8940ca"
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