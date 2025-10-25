class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://ghfast.top/https://github.com/pgRouting/osm2pgrouting/archive/refs/tags/v2.3.9.tar.gz"
  sha256 "54657e2e6769a48fb04dc5653f7956da17fc56b3ae245d1deb41014af9a8314c"
  license "GPL-2.0-or-later"
  head "https://github.com/pgRouting/osm2pgrouting.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f902b81e1cf18e547a9539607705e277a8468747e04d17633bd195ff35b3063a"
    sha256 cellar: :any,                 arm64_sequoia: "53448447f9c571b28ccc68e988c522b8670fe899d3ee00c50045b62a23fce394"
    sha256 cellar: :any,                 arm64_sonoma:  "47450d40085d78241a6c8662971e6d7a506b54476b9f553eb9d03c02e06c2373"
    sha256 cellar: :any,                 sonoma:        "ed9a14a625bead0a5149afd166e65b820c25336eb4b8c9530735c1e421e712fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b1951305634638e9148826dd21f73ec1c5c1749ee85662699623154a3444bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d363a7abbcb544e2a8852e16890692a5c57cbf6a7f3da186ee3ae2899cdc0c5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  uses_from_macos "expat"

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(Formula["expat"].opt_prefix)}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    remove_brew_expat if OS.mac? && MacOS.version < :sequoia

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end