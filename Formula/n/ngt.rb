class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.3.13.tar.gz"
  sha256 "30f2d954e9ff025d094f097132247ef43cc0f0202a1599ab87d1fdee8f5be6ff"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ba4dc92491dc51a1e20d5ecaf6bd7da7a570cd75e3aa7617d017799b219ff69"
    sha256 cellar: :any,                 arm64_sonoma:  "319986ae201f7f173d24836250222ede5aab63e27ca16a4075b30995f4fcec26"
    sha256 cellar: :any,                 arm64_ventura: "39e18667d86049015e0b5e7257565bf733f5941b0b5c33af5c303e8de62910b2"
    sha256 cellar: :any,                 sonoma:        "73d73cd1fe59b37ca77ab023e2dd723bde7be0d1ace1a42ea30c61d9a88d6241"
    sha256 cellar: :any,                 ventura:       "86b9bfc22072572fbd6e51fd2bf91519f6690773398c3f8e1c3c300624e4e886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c32c5db4281bdb4b518c441603dc96680d15d1d9991f8ef8b7a59e1d286b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ed78bbbab2f812a89adde0b07893ff513465c567d7d0349fc56f59b5072927"
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