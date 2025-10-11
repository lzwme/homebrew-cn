class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://ghfast.top/https://github.com/xrootd/xrootd/releases/download/v5.9.0/xrootd-5.9.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.9.0/xrootd-5.9.0.tar.gz"
  sha256 "e08e6fc73aeab08e56f716adafa9476cdfd293e28c14d0af5b1a67c06b1e6831"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77aa98f0cb4e40a0590508e8a8ef2373cce49b7706c04c41c3cd5ebbcd64941d"
    sha256 cellar: :any,                 arm64_sequoia: "8852984facdf87e62f1394c85422e6c552e63e5c7b23dbb831e4e2da8f7b34a2"
    sha256 cellar: :any,                 arm64_sonoma:  "e1d4b00b64d4159fd9644c0106b584eaa51cd04a18eb5edb8e186e823f1a7a8b"
    sha256 cellar: :any,                 sonoma:        "fd5b48aade6ea6ef95be46ed44696d1b01625067f40d8b0eb70abf3f2d7ae7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673dc526d34f42e71fa71669a6a6bec7890834ef1cfe1e9d29c008e1e2ada223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d283cfff8df33374fe670920a15799204eb765340fd439be44ceef435f6044"
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