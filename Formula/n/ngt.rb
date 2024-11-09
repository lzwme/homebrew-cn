class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.3.4.tar.gz"
  sha256 "b6c75a32c68571e00ca73c4f7c5ba94ac405c4e6c1ef79850eb2aff0ebf144ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de4fa2affe294c49e080b6a65e61d92f44b826ce0c9705ff84b2bbb297040b51"
    sha256 cellar: :any,                 arm64_sonoma:  "0a94facfeb0636534083e62e00b26ee1dda32d7e8a11b4a7f19b34176ba7171e"
    sha256 cellar: :any,                 arm64_ventura: "2dc0742325a9c226a4b41d13cf603e91bcff24a98d4d2166a487f3462e0100e7"
    sha256 cellar: :any,                 sonoma:        "5a50304773cd0a186d86945808bcd09d105861b1506d3b1d427bd5549dbf4192"
    sha256 cellar: :any,                 ventura:       "880dd3ca00416a71de902a3173232dacce792a0c20b55a2a9d4f2a77c6f476c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5861de33ff5be056ca6cf00a8e16b3ae47697b23781dfecd8c310e95b98f3bd4"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare"data"), testpath
    system bin"ngt", "-d", "128", "-o", "c", "create", "index", "datasift-dataset-5k.tsv"
  end
end