class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://ghfast.top/https://github.com/xrootd/xrootd/releases/download/v5.8.3/xrootd-5.8.3.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.8.3/xrootd-5.8.3.tar.gz"
  sha256 "8d7ac76eff83540c595a290c56e9cb493d582a93af743e7ef4b4160289c25ff3"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1e609819ccacfb7b1eab2f3fea963877af14bfac8a3c46750489a4ce5bb15cb5"
    sha256 cellar: :any,                 arm64_sonoma:  "81efb994b910e12272c225a07e9afda73c9203a65dcd442fd9c26f37373894c9"
    sha256 cellar: :any,                 arm64_ventura: "4e8cd477de5860c3fc84a70f191da29c2a1382a241c4cc8b68c3a1f5835b7f06"
    sha256 cellar: :any,                 sonoma:        "ec67c78d80365531fb875d7f1b278b8ed7bddc0ff38a87b1757897408792198c"
    sha256 cellar: :any,                 ventura:       "32402d094970dad5850059d637a17f1dbd37823a9954edd6385cda2a5cd5d86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d905bba9b5fc3b2bb748dbe60504a7dec164f617aebd07f63baf020eb16bb883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e7863245df827fc0d879a95c0e43a809a8aff9bcfb85e0ed26812ca6e099a6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def python3
    "python3.13"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPython_EXECUTABLE=#{which(python3)}
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xrootd -v 2>&1")

    system python3, "-c", <<~PYTHON
      import XRootD
      from XRootD import client
    PYTHON
  end
end