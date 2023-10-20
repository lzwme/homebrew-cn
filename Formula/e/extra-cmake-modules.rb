class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.111/extra-cmake-modules-5.111.0.tar.xz"
  sha256 "555d3c1dfa6727b4e64a35d3f01724c9fcd6209c2a41f2b2297c39ed7aabea9a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "031303ef0f77cf7c74b6fdb94bb3c87cf2a699d30e940af6bdb0722fb9d18ecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d38a782d20294371b3b756af11a25f9f236c473240216c172d36b98d082bf978"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "031303ef0f77cf7c74b6fdb94bb3c87cf2a699d30e940af6bdb0722fb9d18ecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "424244bed16555f4345bba58e75d0c0f80211128da1e224b557b1bcfb8081f3c"
    sha256 cellar: :any_skip_relocation, ventura:        "47cf9ebf3e0a815afb9c68020fe773e61ccd307fcff6aada06cb720b772d44d9"
    sha256 cellar: :any_skip_relocation, monterey:       "424244bed16555f4345bba58e75d0c0f80211128da1e224b557b1bcfb8081f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad949a9d92811869583c436abd0acd41b97fa0485f5dd8db8608431ec02cca8c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end