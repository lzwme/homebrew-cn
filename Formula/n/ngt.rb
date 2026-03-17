class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghfast.top/https://github.com/yahoojapan/NGT/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "4c5e18a2b2acf50af3eed2c30e096102c5a4a231ac5ca86efa7b8d0e9d4bd150"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f21a5d94935ed80a78c0b28515630be37c76ba4ea1ee0fc9db375df52eaab51f"
    sha256 cellar: :any,                 arm64_sequoia: "9635830ae6638c47f5d1b92ea394984ae2290765818c0348627c7fa787a6e3b4"
    sha256 cellar: :any,                 arm64_sonoma:  "bede91f5ec1d5b4e8dff1f08564dc652b0b194d033edbc6f6afd435d53c36e3c"
    sha256 cellar: :any,                 sonoma:        "5123435b617aa8f236874b52644f9633cca097d465faa555624bdd7bc1c19a10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61fe99d3cf570991a569dc87ba7ac0ad0571b35e86ff13724c845ae2a0d25091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c37e709c34807d3d5290038515e8933c2c5275c6c38d3df0b45764d2af4a3fb3"
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