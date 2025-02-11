class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.6.tar.gz"
  sha256 "0a1012887fad84119510c59a981ac864a61bc45ec9b1b4bb258e3e042a5653b2"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56df710b73a5fa3948118b00ff5e16487714e9a38a45ad2c18ccf62b2b4dcbf9"
    sha256 cellar: :any,                 arm64_sonoma:  "8a366fd57b67835f743f0a52a50363ab9866204c995972c8297d437b283d7bb3"
    sha256 cellar: :any,                 arm64_ventura: "5f5e0d2a1a047d2c2094c01eec7ff7dd2582e84a2496e2048f33f864b76bb48d"
    sha256 cellar: :any,                 sonoma:        "da723ffc25742025f976ac662e8a72d23f71871f24c7951f042f9d6eff34a646"
    sha256 cellar: :any,                 ventura:       "0d15bb63066c639b0be4380038c2b2773f5f77e6b4183f44245ae0e1304c6848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f3ff8f3e7b43bf3fca41a5b5d68cf1eb9321481ddf7a41179a3acdfc6afe96f"
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