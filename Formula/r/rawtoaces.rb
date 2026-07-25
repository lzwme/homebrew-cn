class Rawtoaces < Formula
  desc "Utility for converting camera RAW image files to ACES"
  homepage "https://github.com/AcademySoftwareFoundation/rawtoaces"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/rawtoaces/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "dd4b53d83aaceb4a4ff97914b5bf1b820c929bd1a480d62c263d1849a8aa56dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8e4e91bae7e2412fd7e0a673db2fa37b2ec6978c6a530e3bd9176c52f42ba360"
    sha256 arm64_sequoia: "ce34996a439638be1749c2002ab1c1e73f3bf319cbeb14a4dfa7c35708e9b0df"
    sha256 arm64_sonoma:  "64f2a8b773c9427f225ad0a9b8a58f2c6f8c2d9e2c42bce8c3823ba04cceccae"
    sha256 sonoma:        "929c6cba7e788c99cb3400851efd4bd87607687762c9ae51322e6aa945fa07e2"
    sha256 arm64_linux:   "3e08c8537db2d84d95ad0cff1cb49e58cf1608d4d3e085d71e1f553320c38ace"
    sha256 x86_64_linux:  "afedd5e9f78c1ab27a7f82993d66c09891ed7139255a62bd48cfe3206142639b"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "ceres-solver"
  depends_on "exiftool"
  depends_on "gflags"
  depends_on "glog"
  depends_on "lensfun"
  depends_on "openimageio"

  resource "rawtoaces-data" do
    url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/rawtoaces-data/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "d84051305009e5a154062f837f62d432bc69f7ad9e220f3a57a056ddc9b8911f"
  end

  def install
    # Replace data path to homebrew one
    inreplace "src/rawtoaces_util/image_converter.cpp", "/usr/local/share", "#{HOMEBREW_PREFIX}/share" if OS.linux?

    args = %w[
      -DRTA_INSTALL_DATABASE=OFF
      -DRTA_BUILD_PYTHON_BINDINGS=OFF
      -DRTA_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("rawtoaces-data").stage do
      pkgshare.install "data"
    end
  end

  test do
    expected = "Spectral sensitivity data is available for the following cameras"
    assert_match expected, shell_output("#{bin}/rawtoaces --list-cameras")
  end
end