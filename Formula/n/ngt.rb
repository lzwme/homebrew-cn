class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.2.3.tar.gz"
  sha256 "0dd5a3f55cb4c49f03f34c46784ab9ecfc10ee9969848ed09db8bdbb100dd330"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9eb09085c9386ad55340ec296a18ea4daa2a7d2321560bb2220f646bb701da21"
    sha256 cellar: :any,                 arm64_ventura:  "95bbe8464597c8c59c664d29808df4c3880e32b2ff9cc067663ffe79efd07748"
    sha256 cellar: :any,                 arm64_monterey: "35ada3499cfafd958c98514eeff4d5e5fb77d9e2bf51e9c35bd67f00807799ab"
    sha256 cellar: :any,                 sonoma:         "9a3e12f4f82e20861d2634c4dade847bafa7f3de25363bd80553e9e875586d8b"
    sha256 cellar: :any,                 ventura:        "c97e636fbb77b31d1e2f8522c428ad9dff9ee1e49ecf71e8ff27e77ec2c33bbb"
    sha256 cellar: :any,                 monterey:       "d81189ea6385c209e00d5a754d6a6ccd7f9ac96a1ab7c57d262ffdce0a053a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a98d65e769d797013904bf48936007379f644aec6e330f834babe99c8fb1cd86"
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
    system "#{bin}ngt", "-d", "128", "-o", "c", "create", "index", "datasift-dataset-5k.tsv"
  end
end