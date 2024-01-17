class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  stable do
    url "https://download.kde.org/stable/frameworks/5.114/extra-cmake-modules-5.114.0.tar.xz"
    sha256 "359ae9ea917fe3ffbb13ff7066dd1dd9750c9a50309737f7d3f43bbd55c6967c"
    depends_on "qt@5" => :build
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f9203cb4bb4d00eef7984ffc94269697619824ecfd3fd4cb406e5e5f2180128"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46c2486e476c56b6f51deaf087413889fd8ca8c9e3ea33217aacea13c1ea3913"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46c2486e476c56b6f51deaf087413889fd8ca8c9e3ea33217aacea13c1ea3913"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ffc69ce591477ea8dffe1a1cdf7d9a4436f6d7f1f725e4eac9dd8f3c1d63f44"
    sha256 cellar: :any_skip_relocation, ventura:        "3ffc69ce591477ea8dffe1a1cdf7d9a4436f6d7f1f725e4eac9dd8f3c1d63f44"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffc69ce591477ea8dffe1a1cdf7d9a4436f6d7f1f725e4eac9dd8f3c1d63f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "688106607026afa5f16a02b508179c3520cd48999ca95a7a038a586faee68125"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end