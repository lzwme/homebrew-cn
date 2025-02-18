class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.10.tar.gz"
  sha256 "7b193521d401d7ac07c01df5f4f246286f4ad10e7a4772c9356335daac8a18d8"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fa5caff7dab4ec5e5d77098660fea971702dbd000525ade16e82857f1bf6bbdd"
    sha256 cellar: :any,                 arm64_sonoma:  "121079ed74c2c165d869a177337b681c6d495ab77ce99cfa5bb1fa81baa626b6"
    sha256 cellar: :any,                 arm64_ventura: "e2c9e161735ecff26949bf7ea0ba45410f27a4c41b3e91c9d98b89b22bab52dc"
    sha256 cellar: :any,                 sonoma:        "7b15099fc3d3a28e3c4f9f89912acafd9d00643ccdab2fa6b77e34953782582a"
    sha256 cellar: :any,                 ventura:       "d856bd5dc1b5b375991286420bfef0bfd89bc1165cd82d1e2ebd35bdcef0f461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c3a70afd8f11342cf1105a155df395ba2410947720c46b9850062cecb4636b"
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