class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://ghfast.top/https://github.com/arvidn/libtorrent/releases/download/v2.1.1/libtorrent-rasterbar-2.1.1.tar.gz"
  sha256 "0f163516ecef2e3331500266751de3098835a3c3ae0c2290448046c632bc0e93"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "da0d73346910c97677eb41af467277a450c8036edd0c43b3231d9f3a6c124d5a"
    sha256 cellar: :any, arm64_sequoia: "22029e5292adb8b353f1914858566799a83986c43136aa112a5cc8b7bd747a3c"
    sha256 cellar: :any, arm64_sonoma:  "f6f9fbac6292ff340cd0208c14b42be2024c5b1bb36c539050e9c7557e1a1f9e"
    sha256 cellar: :any, sonoma:        "3eb3b644f5049e269a5f82590c35e3c69837adb9b6930a84160472c24f6a6998"
    sha256 cellar: :any, arm64_linux:   "8e61067dead0229f00f3e3934aa16b1cdc3daf6674719e1af59594043dd23cbe"
    sha256 cellar: :any, x86_64_linux:  "810650bde78dd17f96a3b3fcb177b6b554b09f648d4e6c6e5e522d60821c296b"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "libtorrent-rakshasa", because: "both use the same libname"

  def install
    # Work around Homebrew's prefix scheme, which makes Python's reported
    # site-packages path absolute and outside the keg.
    site_packages = prefix/Language::Python.site_packages("python3.14")
    inreplace "bindings/python/CMakeLists.txt", "${_PYTHON3_SITE_ARCH}", site_packages

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DNO_EXAMPLES=ON
      -DNO_TESTS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-DTORRENT_USE_OPENSSL",
      "-lpthread",
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
                    "-std=c++17", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_path_exists testpath/"test.torrent"

    system "python3.14", "-c", "import libtorrent"
  end
end