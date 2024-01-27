class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https:xrootd.slac.stanford.edu"
  url "https:github.comxrootdxrootdreleasesdownloadv5.6.6xrootd-5.6.6.tar.gz"
  mirror "https:xrootd.slac.stanford.edudownloadv5.6.6xrootd-5.6.6.tar.gz"
  sha256 "b265a75be750472561df9ff321dd0b2102bd64ca19451d312799f501edc597ba"
  license "LGPL-3.0-or-later"
  head "https:github.comxrootdxrootd.git", branch: "master"

  livecheck do
    url "https:xrootd.slac.stanford.edudload.html"
    regex(href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88b74cc16d94c5d22aa5225a4133940ec5a6f01c0abc83a9dec305083ca71d3d"
    sha256 cellar: :any,                 arm64_ventura:  "bd0e602b8fee4fa04be4309f21201b91a1a2183d2175bf9a7e429206ae2d3c31"
    sha256 cellar: :any,                 arm64_monterey: "3fc0b9ee8e3aab09fae880fa15614d20cd5562d0666ee5bc4eaf8415f91b7e67"
    sha256 cellar: :any,                 sonoma:         "52c6667901ffcdcc296a69cdb1390563302b69b0b2eb2c94172e2ed2ba1f1c18"
    sha256 cellar: :any,                 ventura:        "912eeee6e8fffa2fe88b29bf274fac6b77b65dc22ef4644eb938f1a4c0d5060d"
    sha256 cellar: :any,                 monterey:       "8bad5e83fe336c3d7d45bbe06ea788afdd61db4c95cb1c1e5a3b4d78492992ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4785ee29804b033beddf68b82093684efde202298055e4976c84285047085552"
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