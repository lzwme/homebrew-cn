class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghproxy.com/https://github.com/yahoojapan/NGT/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "fe1c1794b8a6c6cc74423a7f214c819a1d542a94daf96b49fba5765338f93fa5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad11676a61c0f000bbcdcb1b9045ff67e5558b0e4dfb6eade11e33a876ad4de5"
    sha256 cellar: :any,                 arm64_ventura:  "0df3e042a8c39e3434b6552f948acd1b4066cab63d7abc2c61468f2a0bf36c0f"
    sha256 cellar: :any,                 arm64_monterey: "73bf87a228f79be1d117ff366e6f4819f6c9236d32b273ee4fa2e4d249ff5efc"
    sha256 cellar: :any,                 sonoma:         "40dd088f037c078b0f76c898193b43dcd48ade9e591fcaf0c6d079e27180ddf9"
    sha256 cellar: :any,                 ventura:        "169e1384ba8c104a88da1e37e609a5bcdb8269c957a7004711609274ec613ec0"
    sha256 cellar: :any,                 monterey:       "83a3e18a49d2e7f328a79c0f2380445661d00c7eed5e663b9f7cf90d2d86dbab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d060a881679cea232fa9046eef5bcc00e2253adcba7363be524bd3d90f52316"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end