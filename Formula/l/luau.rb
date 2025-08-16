class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.687.tar.gz"
  sha256 "e7c852cf7c260971e55fa6efcce62f367e5f8755426519a2eeff5384fe3002c0"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acd2bb25da4b70ba9aa3ea0ba1d3975996b4e40f11215059dd8aafc96521c106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f7587229ada4eaf0de83190c30c1a1ab1d8d1e7f0824cd5ff6b034d7b2041c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7bd9564bda097f5d2c4ad3f60cc1eab86981ba611c81383b3504b8fc7e6af70"
    sha256 cellar: :any_skip_relocation, sonoma:        "413777a2e5befaf924ecb24985bb0e8127d1bc8036ff7dfacbeb668b3de10a5c"
    sha256 cellar: :any_skip_relocation, ventura:       "abca4e3a46aba78be075a5e857490cc27ea32771f7d8e36153afaaec59865b72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d5a754e617fc6f7cfd72c2aab395c9a7c884b69c9deb8e704e8e3aeee8169d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fde15a21a2b87635005dca35bebe36d911df390f1d180ebb27715658a25e47db"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end