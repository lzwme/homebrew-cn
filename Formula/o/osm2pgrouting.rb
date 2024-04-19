class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https:pgrouting.orgdocstoolsosm2pgrouting.html"
  url "https:github.compgRoutingosm2pgroutingarchiverefstagsv2.3.8.tar.gz"
  sha256 "e3a58bcacf0c8811e0dcf3cf3791a4a7cc5ea2a901276133eacf227b30fd8355"
  license "GPL-2.0-or-later"
  revision 12
  head "https:github.compgRoutingosm2pgrouting.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "965bf8fa9c631c6e9dbff578f066d1bc7e58448c3046caa367ac5925f62bdd41"
    sha256 cellar: :any,                 arm64_ventura:  "145289a6d781ae14d45509d44afae89ae399470b664391e8bf118b6fc1cfd971"
    sha256 cellar: :any,                 arm64_monterey: "bef2eeedd4902d8e1e4909eef4313da9788a7e1b12b9a9f48b21c714f999868f"
    sha256 cellar: :any,                 sonoma:         "42bc5a3b3ed3c22c40a6a8cbac93240d93c27c62994e98ab1ee20bbe97b50092"
    sha256 cellar: :any,                 ventura:        "5d9a9effd922d544de65f3722e2dc95d1434c91c005fb2358edc47dcead175ce"
    sha256 cellar: :any,                 monterey:       "ce67dedef5f8600e6b71a5a5248ef78657fbcdf14a65f7bc94b8fe5884da227f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9bf4bc169e782224b7a4547e24deaca715fb5fe11bfbb2efb012d317e58bb9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpq"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"osm2pgrouting", "--help"
  end
end