class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.12.tar.gz"
  sha256 "fb7e2ed4a63ddfb3894ef03f2553c1a020d5c8cb1a89475e240a95fc0e45c9f5"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cae3f0be38d8d00a8bb919785d0488df63210619a88a742efb92960b088939b"
    sha256 cellar: :any,                 arm64_sonoma:  "8df212262158299ce6fdf185417cc266149d2a007624b6bea9a0384fb2a7fe1f"
    sha256 cellar: :any,                 arm64_ventura: "2d6bb9b2be2a7e81f03da54b4a4307f9febeda5470ece644ad17159c492b87d4"
    sha256 cellar: :any,                 sonoma:        "65c698b14e48c6031ed33b71f4cae5d0d368b1adf756c8f37bcfe35c21160bbd"
    sha256 cellar: :any,                 ventura:       "6a825308985b983753be6304adf6483c19a7b7c690d05c5a647c0280d32b2059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f856e287cae603e312debdcd19c9edfe96eedebf076f3a3d2c885d433c69b90"
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