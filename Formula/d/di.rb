class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.1.0.1.tar.gz"
  sha256 "21d925d6e625cc4ddcc33ccce4c4b3fa427e2faacaee90451b0e1917717a6a4f"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f136f49f08dc4b7448265b051ea98c9985145ab15bed14b2be5634d8e8b952a8"
    sha256 cellar: :any,                 arm64_sequoia: "819c061fa81ce46700ccf34941ab28e69ee7ccf559bb5098b6dcc52a6e1d3848"
    sha256 cellar: :any,                 arm64_sonoma:  "97e69370dfc7c924c8acf9ff24a86638d8a441312efd2b4c4622892038cbb885"
    sha256 cellar: :any,                 sonoma:        "268077c0b17e920c6144286a86cc93a0b1eb5bd1c931d4e3e135e1ec593ee1d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fef5c422bb8a7738aed7c8bae83f6d16aa5939dd4ea212f2e191a6d0e12f287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a3b495dd36635d0aaf0af505736ddafde7d7c04ece43b247c3a3b0bbbd3a6a"
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