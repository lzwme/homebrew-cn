class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https:www.scipopt.org"
  url "https:github.comscipoptpapiloarchiverefstagsv2.3.0.tar.gz"
  sha256 "7e8727b8fcb9c58712e00276d6c342b0319652d0f1c665472af9d22475bce9c1"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aedf3b57e9bba79c4f68ba77ecae2343335457badc86bcb8ff8e203fa01d189e"
    sha256 cellar: :any,                 arm64_ventura:  "93568788db903fe17b2e80eb2b8cafe9c735ca89426ddf75271995415e76228f"
    sha256 cellar: :any,                 arm64_monterey: "2de8750104ae2046911cf16052b8261330d1074d495f75bc75fd20afa52531dc"
    sha256 cellar: :any,                 sonoma:         "b0f1519abf0e4a152309036f7209f643329f8a2a29245754ef3e7f0cb30ed796"
    sha256 cellar: :any,                 ventura:        "91d56f85209d76eff2d1f6f780014a5739444f2d778013c56e41a06b9170be8d"
    sha256 cellar: :any,                 monterey:       "b9c58199c086a50610baf724cba38fbcef5ab25ee6415ccc10cfb320416d1f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a2c663a672311dda26cbc875bfbdfb272303e359e60bb7812dba8a34766037a"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc"
  depends_on "gmp"
  depends_on "openblas"
  depends_on "tbb"

  def install
    cmake_args = %w[
      -DBOOST=ON
      -DGMP=ON
      -DLUSOL=ON
      -DQUADMATH=ON
      -DTBB=ON
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-B", "papilo-build", "-S", ".", *cmake_args, *std_cmake_args
    system "cmake", "--build", "papilo-build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "testinstancestest.mps"
  end

  test do
    output = shell_output("#{bin}papilo presolve -f #{pkgshare}test.mps")
    assert_match "presolving finished after", output
  end
end