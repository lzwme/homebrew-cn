class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https:github.compoac-devpoac"
  url "https:github.compoac-devpoacarchiverefstags0.9.2.tar.gz"
  sha256 "ac96de35709bd37b6ec55d9068fcfc637b7a6a47ad64e66df5696b18de8b5fc1"
  license "Apache-2.0"
  head "https:github.compoac-devpoac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce910c32587689111af7eb22f989b2324771499833e30d7abbdcf566f5f09c40"
    sha256 cellar: :any,                 arm64_ventura:  "c77716ae2415308581a7a94a4b18975b90ff28144e991d7a293163e795627803"
    sha256 cellar: :any,                 arm64_monterey: "7f5287dd6223a73bbfe7099d401419603446fda137cd2e85ae41eda81a4faedd"
    sha256 cellar: :any,                 sonoma:         "91dbbc639853f6ae9b8d74e99933399f601f132f1da00aab338b7e27f39566ed"
    sha256 cellar: :any,                 ventura:        "7d2ed4da5aaea679956a820b5107f3e8b02da5367db1a19913a84104dc58aaeb"
    sha256 cellar: :any,                 monterey:       "6608355087314368edbc7842e2f14ec66fc53b8ad5f90286d5fc3b5cf0e2fe1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79b3b5e37a0d7a85aa8e0c687b3d4c6f895fb3c091d288ef4da5bc146c021965"
  end

  depends_on "curl"
  depends_on "libgit2"
  depends_on "nlohmann-json"
  depends_on "pkg-config"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "5" # C++20

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin"poac", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}poac run").split("\n").last
    end
  end
end