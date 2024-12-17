class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https:www.libtorrent.org"
  url "https:github.comarvidnlibtorrentreleasesdownloadv2.0.10libtorrent-rasterbar-2.0.10.tar.gz"
  sha256 "fc935b8c1daca5c0a4d304bff59e64e532be16bb877c012aea4bda73d9ca885d"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comarvidnlibtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:[._]\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3637c0a0afbaac9de9591c08696dc4f682d0ea91d939bcfab539f865001f77a9"
    sha256 cellar: :any,                 arm64_sonoma:  "66efb6698103963c2710a5de5fb425e8a26df2220467c940e482bbdb9ec9382a"
    sha256 cellar: :any,                 arm64_ventura: "4eabef41b274962921d5b0a33a5141134fd068d1ea4befb427c987e4f8ae2d3b"
    sha256 cellar: :any,                 sonoma:        "2a90dcc6d9c9a7f65d15d14c4de7908d314e1fe56fd5cf21ba963ade720f4d3a"
    sha256 cellar: :any,                 ventura:       "d68b41439aeddea972b3d806cd3cfba2ecc32177cf92158375dae77441e63431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "342ff9810e98909f4b998a77de864457dd90baa2ae50f31e6459b40c8a4e8f10"
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
      "-I#{Formula["boost"].include}boost",
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

    system ENV.cxx, libexec"examplesmake_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system ".test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath"test.torrent", :exist?

    system "python3.12", "-c", "import libtorrent"
  end
end