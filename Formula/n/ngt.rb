class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghfast.top/https://github.com/yahoojapan/NGT/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "95fbdc7d82f41ca85de7aadb1f59480d8b8518efcb24010f636c1eb39fa5550e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e264dd85281cb3b3614d2177d063a2359fbd6bdc8db552ea3a20784b2416be52"
    sha256 cellar: :any,                 arm64_sonoma:  "09fe530bfdea4b99371d3d9abee22351d7ff37ec397f0407b45b3e8ab418b09e"
    sha256 cellar: :any,                 arm64_ventura: "45a2986b9aabba864b9923b3f60cd35b5a3ee25f36a3783c396aa0c8941e8e25"
    sha256 cellar: :any,                 sonoma:        "3976ad747e4d7ec3a75b467f086e62c9226230461df7843959295028969c9abe"
    sha256 cellar: :any,                 ventura:       "f58443e3fbc61f26d62d8fe23fbf24e6e536a841bc7f9e12064e4cfa2899f8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73d43e214c042534669abb8cf79093b4c6ce011cfac5528b0f46c63afe25a6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c85f2a61bc947a973dfe490cb04d677b0b19a7ab008461e48616ee53909067a"
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