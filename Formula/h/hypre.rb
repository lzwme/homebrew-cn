class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://ghproxy.com/https://github.com/hypre-space/hypre/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "8e2af97d9a25bf44801c6427779f823ebc6f306438066bba7fcbc2a5f9b78421"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "207a034da7dc1d7af3ec515d7784d4626b98be2d740cf9bd6e6c4c557af562c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89f312b1755a2712f2d9d8fbee593fc4d91538db9aabb385bb5333e332961103"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71e510de3a9c31a1ff502b61c82cf5d227851bad9d90011563c7caa3b91f8407"
    sha256 cellar: :any_skip_relocation, sonoma:         "66c9226679060da628d78d81a7aff8e43a0bb11c12a60c4079f47c11f4d890be"
    sha256 cellar: :any_skip_relocation, ventura:        "9207e027bc5c7044df0526f7df958e4095f188b4aeafcf0465159b78dd0712e4"
    sha256 cellar: :any_skip_relocation, monterey:       "5d6148a1b20254178d65cd142429219dbccebb630104bd5385a6b0ba05542de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ffa4f4fd990e3ef7a65f3ed1381bdd00a0262191d87cef97311147e6cf15eb"
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-MPI",
                            "--enable-bigint"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end