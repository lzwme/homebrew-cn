class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https:github.comgooglebloaty"
  url "https:github.comgooglebloatyreleasesdownloadv1.1bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 27

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "49bd8394340c077464cd39393fc43ca286314f052ff21c542ab3f206d22252dc"
    sha256 cellar: :any,                 arm64_ventura:  "fabe067922936ef839ee23d5a3a97f04d5769b3be77ba4f6d47b251fe3ae2c8d"
    sha256 cellar: :any,                 arm64_monterey: "bd7fbf8d2b27d515dc3fef1d6ecd8cab91db4a84ad15e941c161dcaaa9c3a028"
    sha256 cellar: :any,                 sonoma:         "934f0e7ace7d04439ae78c74852de04e98b92df874ac24f215d6f35ef0ff2feb"
    sha256 cellar: :any,                 ventura:        "73e4dc872b46027c6ecd4dc13528db0c5479fc94ba1707c2f7fc1b8911c0c293"
    sha256 cellar: :any,                 monterey:       "390199721d8c0f0086d24f964c05742f2f3d39b25ce8c750543206bdbe446abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e9f4e03eafaa83f3f3e033631c5080673f9e880168ecdabb0188a9a3be7cf8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https:github.comgooglebloatypull347
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches86c6fb2837e5b96e073e1ee5a51172131d2612d9bloatysystem-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https:github.comprotocolbuffersprotobufissues9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath"third_party"dir) }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
    inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL,
                 shell_output("#{bin}bloaty #{bin}bloaty").lines.last)
  end
end