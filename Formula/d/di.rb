class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.5.tar.gz"
  sha256 "47522146deab224f94df02e67c5256295795690cf70f6a71d361f3efc497a175"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45a8717f2b13c99d1c57c6c842f4116b3fd28a3bc8133c471b242f7b7f0db443"
    sha256 cellar: :any,                 arm64_sonoma:  "265f8db59202782e8bc914d331c027ba383bce158b44e60d777d0b1c57107e2e"
    sha256 cellar: :any,                 arm64_ventura: "589417446f4fe804cb9c9dff09ecbe804e87d50d08d81991125f815671326511"
    sha256 cellar: :any,                 sonoma:        "54d766716972b004c8059367f4b0d9fa8807ff59a6940e58e96786524f40e7a8"
    sha256 cellar: :any,                 ventura:       "5e095bebb5287c60fbaf4c4c925f548b1f73bddb7004c8bf2b6ffd8a6dc9415f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db05ea65f47dc3ba0a425039f6bdd5c3294a715306d48924e4515e4a205eac38"
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