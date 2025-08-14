class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.8/scotch-v7.0.8.tar.bz2"
  sha256 "f4f05f56ad2c3219d9c6118eaa21d07af5c266cdc59db194b5fd47efe1ec1448"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d8c5fe3782cbbd1be8139687292c7667ab7e8e7306effba8d3fa573d0fa31e46"
    sha256 cellar: :any,                 arm64_sonoma:  "8a1d849b18952d91af7b83a72a6de05fe9b196ce127623cd5a58b93d77443c7e"
    sha256 cellar: :any,                 arm64_ventura: "f98001ad9ecb92be30b197af939f2b5d4a78ded4847a2849c006b52fc4bfd9b0"
    sha256 cellar: :any,                 sonoma:        "baf9ea8176f013b20b5cb5458ca2d563a68f9f8909f8747f016b73f3c1aa4140"
    sha256 cellar: :any,                 ventura:       "b875b519ca2e79ce4a5b5f00a144402e55c2b8aeb8da23280e042b7bedf7718b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec2f1cac4183664702034026eac0c5a8a21c5a246bc7933627ace790e1c59f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e126c4c82ce24aa18666fe306f42bcf6a3ba2b903ca9069a1980564dcce6a44"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "open-mpi"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_TESTS=OFF
      -DINSTALL_METIS_HEADERS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"check").install "src/check/test_strat_seq.c"
    (pkgshare/"check").install "src/check/test_strat_par.c"
    (pkgshare/"libscotch").install "src/libscotch/common.h"
    (pkgshare/"libscotch").install "src/libscotch/module.h"

    # License file has a non-standard filename
    prefix.install buildpath.glob("LICEN[CS]E_*.txt")
    doc.install (buildpath/"doc").children
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <scotch.h>
      int main(void) {
        int major, minor, patch;
        SCOTCH_version(&major, &minor, &patch);
        printf("%d.%d.%d", major, minor, patch);
        return 0;
      }
    C

    args = %W[-I#{include} -L#{lib} -lscotch -lscotcherr -pthread -lz -lm]

    system ENV.cc, "test.c", *args
    assert_match version.to_s, shell_output("./a.out")

    system ENV.cc, pkgshare/"check/test_strat_seq.c", "-o", "test_strat_seq", *args
    assert_match "Sequential mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_seq")

    system "mpicc", pkgshare/"check/test_strat_par.c", "-o", "test_strat_par",
                    "-lptscotch", "-Wl,-rpath,#{lib}", *args
    assert_match "Parallel mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_par")
  end
end