class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghproxy.com/https://github.com/yahoojapan/NGT/archive/v2.1.0.tar.gz"
  sha256 "e2a4283509ee67c1571ea4752e37faeaf20cad06fc630ec6a98c10ebb7ff537c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b613737488ce4ecbae0b97133972d2eef73171cc35a775bfd5d94617df91fc0c"
    sha256 cellar: :any,                 arm64_monterey: "256e56f3ed857789a180fa348775d6350e691ff30bded1ffdf848ca4d8c70d93"
    sha256 cellar: :any,                 arm64_big_sur:  "4a4787338e2ebe9e0ff8ca67be95523a119f4a41aa568749fb40c350b3a059b1"
    sha256 cellar: :any,                 ventura:        "e74f7e1df53caded6c7f7f27d926a041dcf6d5f83a023f83bc8d3208922a80f3"
    sha256 cellar: :any,                 monterey:       "4e4a44645dee80afddb7071d945855570747a786bcfb4c5c20816bb6e8cadb51"
    sha256 cellar: :any,                 big_sur:        "51176f26b2ac23681976a9658c5b7f4b682857cc167677d70ba1e0e51ce445ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9bd5d522c86fe58588f3e3579fa2b34a06fb188aaf4d776f40843d84f407edd"
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