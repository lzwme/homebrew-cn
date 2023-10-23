class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://ghproxy.com/https://github.com/arvidn/libtorrent/releases/download/v2.0.9/libtorrent-rasterbar-2.0.9.tar.gz"
  sha256 "90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3179ae10a0acd273c5bfc287fd9cfe62b6e1ba39052e475e362de43d66a30c6d"
    sha256 cellar: :any,                 arm64_ventura:  "2ddf7b7b31cc03f6334e426fb08f2c94ff4834119b219fdcb6d60f9923ab5a34"
    sha256 cellar: :any,                 arm64_monterey: "79ad82aa82cec56cf13e6cc06830141309e2a4592d55b65a46af464137a92361"
    sha256 cellar: :any,                 sonoma:         "1d1f18379d1d8513a1e941b02b1df0090b72d28efea8f40bcb9670ce13bbe1a2"
    sha256 cellar: :any,                 ventura:        "56b7065bb0d70d3440cec7a3eddaf71f6da2b2f7cd34d28d35dfb96d00a13c58"
    sha256 cellar: :any,                 monterey:       "5e9282816acf457f696a2ce53b3d44da67eb2b4e9463ba51bfd1fce500f96d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86cc11f756add016fac5db365e033bdf50d343f031f760f673025c2089002b2d"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.11"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}/boost",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-lpthread",
      "-lboost_system",
      "-ltorrent-rasterbar",
    ]

    if OS.mac?
      args += [
        "-framework",
        "SystemConfiguration",
        "-framework",
        "CoreFoundation",
      ]
    end

    system ENV.cxx, libexec/"examples/make_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?

    system "python3.11", "-c", "import libtorrent"
  end
end