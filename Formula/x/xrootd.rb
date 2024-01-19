class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https:xrootd.slac.stanford.edu"
  url "https:github.comxrootdxrootdreleasesdownloadv5.6.4xrootd-5.6.4.tar.gz"
  mirror "https:xrootd.slac.stanford.edudownloadv5.6.4xrootd-5.6.4.tar.gz"
  sha256 "52f041ab2eaa4bf7c6087a7246c3d5f90fbab0b0622b57c018b65f60bf677fad"
  license "LGPL-3.0-or-later"
  head "https:github.comxrootdxrootd.git", branch: "master"

  livecheck do
    url "https:xrootd.slac.stanford.edudload.html"
    regex(href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e15e06bac391f7b43855f145aa22abc357a9a66171b5e84a572f651dc8331784"
    sha256 cellar: :any,                 arm64_ventura:  "1136c7eef69dd2e2387d6125822ee8ab7f12342997c16ea63313dad2874142ea"
    sha256 cellar: :any,                 arm64_monterey: "10f4bac8a6520578976c0ebd71a5d740a35acea9eef77dc18bffc1cd3fe4ab90"
    sha256 cellar: :any,                 sonoma:         "b7f56a6c24e11f0c03fe256083c448a9feba4ad846547627b7015915325e620e"
    sha256 cellar: :any,                 ventura:        "0c63e9cc616cb78c13adfe1504f5e2735ec91b5a09c39d72ddcf3a98ee304190"
    sha256 cellar: :any,                 monterey:       "00b744d84750b7154d7231463609489e5ab98eb70cc1f57e46669376d824720d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac6b09cb019a4aaed127161c54aa0cca32161c1986133baeaecfbf28d0de6f4"
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