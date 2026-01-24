class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.2.2.1.tar.gz"
  sha256 "4bc92e7c99b15d700de1a5faa8159d6f854d257b9a32f17b2a9e834a19b1b3d4"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d9289bbda4e95d7d3b1af62d3c7c98145148a13b19ce1c3ae504562ddd567d0"
    sha256 cellar: :any,                 arm64_sequoia: "205151f918686a01249ba55e12c5016f3656458aa89fea10f793cddaf3b948a2"
    sha256 cellar: :any,                 arm64_sonoma:  "17bdf29f1daf502f9e75bdb0f172d52342f62e378c901e78157f11e7090839dd"
    sha256 cellar: :any,                 sonoma:        "8d794c3c0def88f98bd8dd5c1682b2b1332855d6917f2b63066df3d389c746be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af1edbe05c897008762e0e95a5d7e25736a16132b34a5d91b2db5ca3aad29ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c59e0eb55d31baece03c949f23c4b8ff0f09fbbdb55710ba1ea50605e92d9da"
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