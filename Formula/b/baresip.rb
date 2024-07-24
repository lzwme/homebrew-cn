class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https:github.combaresipbaresip"
  url "https:github.combaresipbaresiparchiverefstagsv3.14.0.tar.gz"
  sha256 "bb886c393d29e6bb5f89395cff1985ba9eda27dfd3aac2a5221ef7957c44b1a1"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "2431632efcffa429d8bf6efbd75ca8d4bccb882c68cba576685430cf57ae1608"
    sha256 arm64_ventura:  "e06d04cd917c42064a2f5cd107f90718d0d7ce9c13e88b4ee51f5faf6d94a61e"
    sha256 arm64_monterey: "99d0b9bd8653c39d2a6a96a3e8ebe0404af37a74fb74ed2b81810c2f370ab25c"
    sha256 sonoma:         "e46d739c29a25a8398409580002a0c61ee572183d70cf4c89ab4961686d8d5a5"
    sha256 ventura:        "56cf154fd5b77a27c9a0e8d61b1eaa73af36138c68ce9bb1c25946bdf9e546ab"
    sha256 monterey:       "50ae7cdd4543c470f5aab8d372e05c78d35256f06e9bc7337c78af5800aaf894"
    sha256 x86_64_linux:   "6b8b5ea0ec9747d16954346b9229bb604ffc837302588607eb4ac614c9aff824"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin"baresip", "-f", testpath".baresip", "-t", "5"
  end
end