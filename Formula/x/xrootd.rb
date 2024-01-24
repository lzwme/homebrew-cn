class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https:xrootd.slac.stanford.edu"
  url "https:github.comxrootdxrootdreleasesdownloadv5.6.5xrootd-5.6.5.tar.gz"
  mirror "https:xrootd.slac.stanford.edudownloadv5.6.5xrootd-5.6.5.tar.gz"
  sha256 "600874e7c5cdb11d20d6bd6c549b04a3c5beb230d755829726cd15fab99073b1"
  license "LGPL-3.0-or-later"
  head "https:github.comxrootdxrootd.git", branch: "master"

  livecheck do
    url "https:xrootd.slac.stanford.edudload.html"
    regex(href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abf5e133b8fd4c01fb4b2b4ac2ff289f649459aeb15f0074cf0f076f9212080d"
    sha256 cellar: :any,                 arm64_ventura:  "2607249f46dd10c454e002c7b7820bc584e3bee3919cceeae4e6719e1384bad4"
    sha256 cellar: :any,                 arm64_monterey: "f2fd3b69c3c45e70e8d6896150fefff095035770e277f73cd3dc9a8277083834"
    sha256 cellar: :any,                 sonoma:         "ca3141fc8bce5c5a9fe8fb14e8dd6f8fd3d4e84007131513fefbd9880119fafe"
    sha256 cellar: :any,                 ventura:        "157195dc0ba9bc5652caff00f374f678421da53b979780787cbb4b9a331f7505"
    sha256 cellar: :any,                 monterey:       "bfd29e1d646fa2b27f05b17efe696aeda5e2c74fabe2fb3441cb222b627e884b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fdc8107e2251784a78d1748fa14d92773dc765c8750d099e1f3c044bf7772cd"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_CRYPTO=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
      -DENABLE_READLINE=ON
      -DENABLE_SCITOKENS=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_VOMS=OFF
      -DENABLE_XRDCL=ON
      -DENABLE_XRDCLHTTP=ON
      -DENABLE_XRDEC=OFF
      -DXRDCL_LIB_ONLY=OFF
      -DXRDCL_ONLY=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}xrootd", "-H"
    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end