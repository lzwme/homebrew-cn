class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.9.tar.gz"
  sha256 "2624c2bbceb55fec1561e23b40f50b9cfcd16d183fdd6b982a0b5d457aa29b41"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce9c7907ec6ecef66646e0d4143458d22fb7fbec202258533fccb02ff92f5832"
    sha256 cellar: :any,                 arm64_sonoma:  "55745f80d82977610919467ec40e6ea034d19707c443493f80b40b2706f799f6"
    sha256 cellar: :any,                 arm64_ventura: "d0d6497c3e93b871d9afc0b6abf7f5aea97861b961f3508b8f9babcc7d1ceb7b"
    sha256 cellar: :any,                 sonoma:        "0d0a862dd6dfda9a3419556c651cab07f8d0e10d3b5d18f7b8e4183b5602ea29"
    sha256 cellar: :any,                 ventura:       "035c531fe019e54a2c1f1ec3b8a3feb16fbe4d8aa3a3d575289bbd93dedfbe4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177679f1260139b7b0cf5a85d0f1499b8334f02f7103f8ef67492450f2281bbf"
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