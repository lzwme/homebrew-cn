class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://ghproxy.com/https://github.com/potassco/clingo/archive/refs/tags/v5.6.2.tar.gz"
  sha256 "81eb7b14977ac57c97c905bd570f30be2859eabc7fe534da3cdc65eaca44f5be"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "a5b9a5583e401929014625ac00c1cad3056436f6e0f58f6a91d043c9428a31a9"
    sha256 cellar: :any,                 arm64_ventura:  "ea1a50158c6e5495898a6b2c66a11c6b9b9b188c347ece36990d2137fe32dc1f"
    sha256 cellar: :any,                 arm64_monterey: "2a0ed139c6cd0754870a54931ccbdde47f8d86636cd3ecb3c8b72937522e595a"
    sha256 cellar: :any,                 sonoma:         "836c42d2599f24afa9fe0404cdddf017f137e427433780651d2a04f103c07a86"
    sha256 cellar: :any,                 ventura:        "d1962c0ec40e2e143c0e1cad09d360f3089fc2f9fac4c3f31069a7ab8f157101"
    sha256 cellar: :any,                 monterey:       "d917e50d2ee2a8dfc1f51b71f7d8c0c9d44eeae4b06f038503c8d5610dfe367c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1637dc9774955b4420e7e603a4075a57267efae2a5a434758badd3741a7f0d"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "cffi"
  depends_on "lua"
  depends_on "python@3.12"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCLINGO_BUILD_WITH_PYTHON=ON",
                    "-DCLINGO_BUILD_PY_SHARED=ON",
                    "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                    "-DPYCLINGO_USER_INSTALL=OFF",
                    "-DCLINGO_BUILD_WITH_LUA=ON",
                    "-DPython_EXECUTABLE=#{which("python3.12")}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end