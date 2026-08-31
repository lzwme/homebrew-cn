class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://ghfast.top/https://github.com/cvxgrp/scs/archive/refs/tags/3.3.0.tar.gz"
  sha256 "d8ef5674ffae585866a257479d2e2ff138fb18601f6ecbb89cd3f057b69f0f4b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3511f590663392565db5b571e61d3c6411d282cdd3644c8de056f840e29dbde5"
    sha256 cellar: :any, arm64_sequoia: "6e91f41adf580e28bae61bf811715e0bf4f6b935e458e6d747ba01f51c227a4c"
    sha256 cellar: :any, arm64_sonoma:  "75ebb4dfa20164e53bd2bd959ae6f4b5cf383f5dbbe4fc6a0b6ead97d4b5111f"
    sha256 cellar: :any, arm64_linux:   "c171403c7fe74bc67bfd1630833e4a72e35aa543fe59bdeca81ae233fe6e4771"
    sha256 cellar: :any, x86_64_linux:  "9104e1a77e684674081e8f14701e9822855d5b5c0fedfc0b2644e2dd497c1277"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/problems/random_prob"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rw.h>
      #include <scs.h>
      #include <util.h>
      int main() {
        ScsData *d; ScsCone *k; ScsSettings *stgs;
        ScsSolution *sol = scs_calloc(1, sizeof(ScsSolution));
        ScsInfo info;
        scs_int result;

        _scs_read_data("#{pkgshare}/random_prob", &d, &k, &stgs);
        result = scs(d, k, stgs, sol, &info);

        _scs_free_data(d); _scs_free_data(k); _scs_free_sol(sol);
        return result - SCS_SOLVED;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsindir",
                   "-o", "testscsindir"
    system "./testscsindir"
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsdir",
                   "-o", "testscsdir"
    system "./testscsdir"
  end
end