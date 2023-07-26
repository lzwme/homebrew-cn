class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghproxy.com/https://github.com/yahoojapan/NGT/archive/v2.1.1.tar.gz"
  sha256 "9f4e2aa9a7fd7d89df36088fd496e6b22f0a7d5cb4e1065e1b463d42ae5aa535"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "357ffe729aa5df8c0922cb1c26aec3abbf25cf5b433c97bfa13f4136281ffbd7"
    sha256 cellar: :any,                 arm64_monterey: "6d1ee419d8b6fe0bcdd028afa5948064cc9ab0581a5fe93e4903d0cb76a52cd1"
    sha256 cellar: :any,                 arm64_big_sur:  "a2749f63af6cdcecaafe3279062bfd8cb43d43bf714f97bba4c2b952f2239324"
    sha256 cellar: :any,                 ventura:        "4b8433273c4221c1766d297ee6fbedf608dc7dc0da34f9b1be0ea1840507119c"
    sha256 cellar: :any,                 monterey:       "154904a9cdc40fdcb8f2f5935ee70a4b24b8b01bc6e1062f7dbdaa05b4b21449"
    sha256 cellar: :any,                 big_sur:        "9acc8547e5df9d24b1326f1ffb8e6e7905d6022c8e663099cc718a8fe5341727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c147442710e9f08613f6a06f41f7efcb2bd8b115ba03e5d8b1f24b440f8c6ef7"
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