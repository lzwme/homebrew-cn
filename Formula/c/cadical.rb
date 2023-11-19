class Cadical < Formula
  desc "Clean and efficient state-of-the-art SAT solver"
  homepage "https://fmv.jku.at/cadical/"
  url "https://ghproxy.com/https://github.com/arminbiere/cadical/archive/refs/tags/rel-1.9.0.tar.gz"
  sha256 "a367e5bc83c4275b69fb5f9e297b270d77705f09ff583aa78cfd1444a6b524de"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e5a0416623f78625e9638b21bb47caa87394109ea71a934a7035557ce8d79d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c18d0acd37f06c42db24c872d193278633ffde46b855151ef53bc19376dd081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f76ded7e63e9b867051f09635e9a0924f4e3cacac2a49e64ea8ffb503a3e4ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "05e0e379852e35bb254842a0d9e3302c124d89068087ea56ae0629ca141bf8b7"
    sha256 cellar: :any_skip_relocation, ventura:        "33e46850edac4057f8a27232108337e96be065eb7f442ef7237dcd31a3f8b3ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b51b880de65862e1dfc11cbaca6bd0dd191a9d046e158c1386e8b92b74275e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ff9aadbfd4baec998bf74ab81eaaea19e7d3aac91013c0bc870409d4653b0c"
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