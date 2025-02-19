class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.11.tar.gz"
  sha256 "49947afa71421a69b64ec1c3814e2fa1881e2db76755afb6dfa9a87fb6f8b07e"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8aef038ad73d4aeaec418afdde64f34c9748cebcc2251d5919e2d7a84b7adf5"
    sha256 cellar: :any,                 arm64_sonoma:  "2f047042c56a55d1fe4091c9ba888c24ce4d4c8f72b4118e53f84215a570ec21"
    sha256 cellar: :any,                 arm64_ventura: "25494b9e58b537c41d766c2654b70b291afffb1b69023a1f5dc3f18a7803f940"
    sha256 cellar: :any,                 sonoma:        "6d053ffdc04ae5cc85999b5b9e8a17d97d898790f568508ef66a99c0633383ca"
    sha256 cellar: :any,                 ventura:       "a2a4a8197591d14580021dd3a12343bd341be982a2eeb1b5f14b820c45bf5e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91ecddb2a27e4b1656cb3f432407a0746452e94e73cc5776d181eca457fb01b0"
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