class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghproxy.com/https://github.com/yahoojapan/NGT/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "9e02fb11a71e596d7f2d3ba3949c6c6730d57b8713afa8dcbaafe67f51923604"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "955f8ceac5b2d5e6beafaae46c016ea3e32e741552419074d48821242ce599ba"
    sha256 cellar: :any,                 arm64_ventura:  "1810bee6e34da6bc772e98b12aa6c158dbfb57c3ab635fcbab6538a888dbd56c"
    sha256 cellar: :any,                 arm64_monterey: "bb2b786f22d50b427ca70e4819f3250a90220b639bc8c40412c85b1698b37783"
    sha256 cellar: :any,                 sonoma:         "27f982e3c74caad5f8084c549dfb687fedcacf5f60cc392463a28242e5c09a43"
    sha256 cellar: :any,                 ventura:        "5dcbb1a05c8d788abc6cdd9cccd8862e64519d69184a71c4dbffbd9f590677f2"
    sha256 cellar: :any,                 monterey:       "d7abf0b4b3eafa92d7431d63be5710d99e0a6e3a752907e733518eca804db4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31867db6d7dfc252079700cf7b3f18d35dc5dc852b0ed098c84f9817fe2be313"
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