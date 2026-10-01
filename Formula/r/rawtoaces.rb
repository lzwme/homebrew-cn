class Rawtoaces < Formula
  desc "Utility for converting camera RAW image files to ACES"
  homepage "https://github.com/AcademySoftwareFoundation/rawtoaces"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/rawtoaces/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "1687f12ce34c3d01d5e3d293dacf14df3d815d51d4595c12321d0262a5adc792"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "1d36e70deea44f06227ce3f2360f2eb6af091abaa6e5765ecfd6f29540b4fdd4"
    sha256 arm64_tahoe:       "5cc1c6d66854d1e915a2347c9c1b6ff1eb3912efb392ea708314a94c2163c435"
    sha256 arm64_sequoia:     "6a5c96c74c15557bf62f3fb8b97693b78bf0e3023dd88d78ff5844f5cbc36e68"
    sha256 arm64_linux:       "254dd6eddbead6eff7415fb5ff5d11c86495487c11735a16b6545b9792e10feb"
    sha256 x86_64_linux:      "d9f6a01a06755f96d9a3c429dc755c23fdd9bd27e8bc999115a45910764d90fa"
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

  deny_network_access!

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