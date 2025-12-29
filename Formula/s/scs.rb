class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://ghfast.top/https://github.com/cvxgrp/scs/archive/refs/tags/3.2.10.tar.gz"
  sha256 "4a6417ff73cdfeea6ddce99c5f10e3d15a3083abb7e44737b4405d24ee8884b0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ef68c58173c8a2cf0d8ad92c0f81f8e6f092d1178c9f5728c2a8dd09f5ea963"
    sha256 cellar: :any,                 arm64_sequoia: "61ffe3ff4c4750851738fb78b3c971c8263ef4165f18e5ac3e43f35d8bb2b778"
    sha256 cellar: :any,                 arm64_sonoma:  "095886205e419d1a80433caadee9ef6767bb2b69e149a7fcedf71ebb61f6395c"
    sha256 cellar: :any,                 sonoma:        "6ff6705f89c87bb1e7cd5e2f0c8d58a3037af838a27d4528109aaa84ce097595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1eec204b006ac6ffc6aadfe90940753a96f78a4c7aeee88da033b52d7b952bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a5da000e6b0f4b4d6f89e53bd6782a95cbb50226357f8b767577c584210d40"
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