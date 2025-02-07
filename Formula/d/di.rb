class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.2.tar.gz"
  sha256 "b2924309064ae79f0058109af6acb688dc07f11b3aa74cda137f93f6a40b3392"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d0a99535f946e489aecde1d8f6d3c2c884c60aa2d06bfb4acedbbe3ba78fb4d5"
    sha256 cellar: :any,                 arm64_sonoma:  "fcf0ca604b6040f95eca0a9fd9ca95a2c43e39e16ddfb9481cf430a3632aa832"
    sha256 cellar: :any,                 arm64_ventura: "3d34f4f969346cfed4f9559fd2db75471848db51cbe6a3bdfe65825613a3b400"
    sha256 cellar: :any,                 sonoma:        "de15261b4cba7410a2fc9efa5fd8771a2b8c09e4890040ef0a6efaef7ae7a943"
    sha256 cellar: :any,                 ventura:       "05b80eba529e7b56233e2cb51bad10644cc2b0fbba17aec9107f4c1e7692ecf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a94540d75f6e87333758aaa39fc286f0e361752038c2e57729e1a512d2ddc34"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %W[
      -DDI_BUILD=Release
      -DDI_VERSION=#{version}
      -DDI_LIBVERSION=#{version}
      -DDI_SOVERSION=#{version.major}
      -DDI_RELEASE_STATUS=production
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end