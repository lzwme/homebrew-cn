class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghproxy.com/https://github.com/yahoojapan/NGT/archive/v2.0.15.tar.gz"
  sha256 "fdc94ff9ef004818bffb304b57a92bc2ef1ca0a9b8d527be833190d3f592c6db"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bce30af7f06cc81df9c95ffb011e4b240c3e3adae56dfa0f4e8fe2e01030d6a7"
    sha256 cellar: :any,                 arm64_monterey: "0aeffed80b4a104de623de1df08642d895c76cfa46d2977cd4f34b6c4c708ec2"
    sha256 cellar: :any,                 arm64_big_sur:  "647e017f3979383052c8d5a71bfc551a08c77274541eae538a136178cb7b7baf"
    sha256 cellar: :any,                 ventura:        "1c297053e6603b38cd7818dd1dd6f98795dcb837f5849b541f68ff5e42302620"
    sha256 cellar: :any,                 monterey:       "d39acb9573d1c57cc90643715885a4d87ae282c01351a2843e04e51db7086ccb"
    sha256 cellar: :any,                 big_sur:        "3113d9b6ebf2bc2051a16df1321acfde45c463ba08816d35a0debf503334e44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bf2957b350664d9faa866cd483048ef5b633b9de14332b0ec25163ff893208e"
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