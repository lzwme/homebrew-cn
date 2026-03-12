class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghfast.top/https://github.com/yahoojapan/NGT/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "6c1348c752be952caefb70b876c9dc7e2afeb48b669d14caa8be4e4e9403f35b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3f5322627f18710c12fddf3027aea02fd3675eef2c1291787335ab9f15f15c8"
    sha256 cellar: :any,                 arm64_sequoia: "154238c27c7661aad2c04589a32fa02810217478442b71ef040de28894d2e766"
    sha256 cellar: :any,                 arm64_sonoma:  "fe96266291ebc386eddc91edfdc8d19496482ad33bc40cc0b16c81a6334e54e3"
    sha256 cellar: :any,                 sonoma:        "2f33b5434183fc0b97a6ea6cc7b3445a1230de5f3c81d4d636ff0cba4a1e61ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc5ff88401c9d5cf67a08f39cfa934d6cec31fdeb1b9a663d8f2d7529d3623a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75871eedf74f0ffe93256e6bfc87e76272befd3d4586f805f2e3f3c681d2b259"
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