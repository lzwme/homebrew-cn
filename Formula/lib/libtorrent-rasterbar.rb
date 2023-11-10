class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://ghproxy.com/https://github.com/arvidn/libtorrent/releases/download/v2.0.9/libtorrent-rasterbar-2.0.9.tar.gz"
  sha256 "90cd92b6061c5b664840c3d5e151d43fedb24f5b2b24e14425ffbb884ef1798e"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a01960cbbb7d1605f4aa1ffe423830863ef11c21ff8d5670debc15ff092dff92"
    sha256 cellar: :any,                 arm64_ventura:  "d31b608684757dd3231a249daf5fc382ed6d7cc1f082d24b76ddbd16fcd12734"
    sha256 cellar: :any,                 arm64_monterey: "71962c3337c1713c6c38681431bff983870772c1d02f905b16b6ba99cab02412"
    sha256 cellar: :any,                 sonoma:         "4633fd7f6faf1123766a0d6ab68092cade9099d830719a35d724d5171c9a1cac"
    sha256 cellar: :any,                 ventura:        "ca1d3acd2b2249f224a99096410fa03abfbbc1d21e31e74fe469b34d8fe8570b"
    sha256 cellar: :any,                 monterey:       "006a89580bb5935ed0711278811f6cdf6cff47206a56545f3b5d7b4a3a34b18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35881f2784b2f8e80aa3493bd80d5d1eb1382db6d2022f353fe99aabfd444b16"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.12"

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

    system "python3.12", "-c", "import libtorrent"
  end
end