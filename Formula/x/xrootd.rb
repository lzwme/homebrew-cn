class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://ghfast.top/https://github.com/xrootd/xrootd/releases/download/v6.0.2/xrootd-6.0.2.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v6.0.2/xrootd-6.0.2.tar.gz"
  sha256 "1270d9815ce196bc2a5e84a8723c06ed6721bc1ede255698f00e131c474d2547"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9df5a569e4bd7923d715563cdc42174d878b32a600d01aca155e270408f3646d"
    sha256 cellar: :any,                 arm64_sequoia: "cd1b31ff431e882178b90a13594c4bf557eb9656ba01583f2c9380cc373552d9"
    sha256 cellar: :any,                 arm64_sonoma:  "1574d1d8ddf3d16261c8b44afad541726b4b7aabc980a74b27f4d32174d97b76"
    sha256 cellar: :any,                 sonoma:        "abfbb2ab573036cc65993fd1c7ee0338a7bb7784370e90f94ccc60b3ebc3309f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f92c8a9ec9c2b330ff88e18bf4ccfdcd68805e3d88d41aa8a33715e3b1611189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efaee9e45ec571eda93ff754e11af801011d628c4a7d2ecd18c1b9ffb62da7ac"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "libzip"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
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