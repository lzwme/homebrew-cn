class Volk < Formula
  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://ghproxy.com/https://github.com/gnuradio/volk/releases/download/v3.1.0/volk-3.1.0.tar.gz"
  sha256 "4f5bb84f535ce86cfadc953379587bdd5a1a171d684b0a6f35adcaf2ac46fd01"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "8c5afb6748c91001cc91dad149293b0aa064ed73255de0411f533826395f4974"
    sha256 arm64_ventura:  "f342dd05417a998c01d9623ce1b3ad152aa4d1140295df276cdded51d27be51e"
    sha256 arm64_monterey: "5bcf5ac6a1ac0d283fb0159b69fb540bafd0dbce7bd6d40937443dbded97cb67"
    sha256 sonoma:         "b803e52f3b1d6cda3370dfb2f13442d47039838accd56cf7e2b97da070510f89"
    sha256 ventura:        "a1f9084ed264904da34adf0ffd1b655627e79cb25f38762b9f367a32b68cc7e5"
    sha256 monterey:       "34923e18438de04b7682907a6ee8d5f95a5997d370d32205791cc3c8b2d64854"
    sha256 x86_64_linux:   "3639e6f0a48fbf6f3b2b271c86768e42e4a2966e55047be42113cc8f141d1bb0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "pygments"
  depends_on "python-mako"
  depends_on "python-markupsafe"
  depends_on "python@3.12"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  def install
    python = "python3.12"

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python)}
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/volk_modtool", "--help"
    system "#{bin}/volk_profile", "--iter", "10"
  end
end