class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghfast.top/https://github.com/yahoojapan/NGT/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "6c3cb11fb62f4ab52a3b6c47ea057a444e2d71506114fbaac83fd8fa3db5f193"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f96824a9cf45270fd9e239582c5033b5c0b5577591fe2b8e0367f7084193202"
    sha256 cellar: :any,                 arm64_sequoia: "27d97eaa69a854fb329e5d3588b3bf2cfd661af1593b57d54c35a670bfb2e148"
    sha256 cellar: :any,                 arm64_sonoma:  "9939521d4c748e85c4126950a476947f70b733db2052573d804d7e065c170283"
    sha256 cellar: :any,                 sonoma:        "1d6ba107a62a6df04d776860ca9e12aa48356a08f66d5d3268b2007e94fb87b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e78a9ba2d08e7c477d6841b9cf901b85f2a1c87731133142490ffb1344921b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d78c262b4baf0078ddbf14783945d1adddf4b75dc19de7bc0795dbc49d6fb31"
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
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system bin/"ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end