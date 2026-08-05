class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/clingo/"
  url "https://ghfast.top/https://github.com/potassco/clingo/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "28fe78322cefb92e0f68f350777e19407d07bbb5179ca725fc6f77d538f0d19a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0e424c4a9e979b143f0326cb78d06438617496fd000297dcfb62f84d6cf6a0d5"
    sha256 cellar: :any, arm64_sequoia: "a7bddee88a7c5df01211135f95760d636026666237a44374cfce6ed349bb7a17"
    sha256 cellar: :any, arm64_sonoma:  "45d9cd732fc516af09949797f5835d6d2996dbbf8b2a28c04eb648d5533c57bf"
    sha256 cellar: :any, sonoma:        "59055292fb91cca6687b37156d29569c58c01686e843bfe0bdf46397f7f67aaf"
    sha256 cellar: :any, arm64_linux:   "17d32bfab00a31b0ae9968b417e4638abe87d01a9549200a3db44ed098999cfc"
    sha256 cellar: :any, x86_64_linux:  "542bc0ee263128d9876bc9e9b296debab3d60ce91bda175e04c7e3f83080f118"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "cffi"
  depends_on "lua"
  depends_on "python@3.14"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.14")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCLINGO_BUILD_WITH_PYTHON=ON",
                    "-DCLINGO_BUILD_PY_SHARED=ON",
                    "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                    "-DPYCLINGO_USER_INSTALL=OFF",
                    "-DCLINGO_BUILD_WITH_LUA=ON",
                    "-DPython_EXECUTABLE=#{python3}",
                    "-DPYCLINGO_INSTALL_DIR=#{site_packages}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
    system python3, "-c", "import clingo"
  end
end