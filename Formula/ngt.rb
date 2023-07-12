class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://ghproxy.com/https://github.com/yahoojapan/NGT/archive/v2.0.16.tar.gz"
  sha256 "860bef86d0b9ce972464547f31e3e3d0f95d3d928f3e26a5fbf5e8104fc1e6b7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9d7cbbb53f3448b6bd84e75212472a4be485dc5f1a5b1b2ddfdc515b8f8d7ea2"
    sha256 cellar: :any,                 arm64_monterey: "8280ef0b0d6c0ef54895db980299fafcbfe2691db34889badde55de1a5180362"
    sha256 cellar: :any,                 arm64_big_sur:  "0f8aa52af6f5372c9dfd329a44e81b0c9580a07fe9ca486ec7e9e7948d50178e"
    sha256 cellar: :any,                 ventura:        "fb323db7afca6b735736bdb1955334256ded92d074d05cd65f6a02bada09e5d4"
    sha256 cellar: :any,                 monterey:       "6284432ecddad3d0ba8a69b00542d1c528992a57e61fb2cbe5415929f181b842"
    sha256 cellar: :any,                 big_sur:        "1890d725173f6fe84438c7f4942cb1bfc3f712fcb4bc06f9ae510eb48a6e4f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47914e0ae2a2ee52e48093789909fab56af4206d9f57ac226808e6ae0911863"
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