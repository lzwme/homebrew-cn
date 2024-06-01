class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https:luau-lang.org"
  url "https:github.comluau-langluauarchiverefstags0.628.tar.gz"
  sha256 "0838255824f5bdd03694bc565bd98a363fa7313b02aec7f693048013277786de"
  license "MIT"
  version_scheme 1
  head "https:github.comluau-langluau.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "700646c98a90b2fbce77c50fab628bd3fb05421d6aff6f4eaef930debd1ba885"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b62b81c3bfe1b9a7969b2af53ff90a27027ea41e9eb11a010bd18421038a653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c068b9df38a171e1b5b81f206bca4c8c32f8589b37dd9d0ac3f3786e4839e9ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba7763c1b9144936f0ea6c136b2d7e6bfb3d9253fae8179cdcc9a7b43c23b5e3"
    sha256 cellar: :any_skip_relocation, ventura:        "2827a19b70daafd054ac29ae336c95a9b9195604aa449fefb1fca396871c74c3"
    sha256 cellar: :any_skip_relocation, monterey:       "1dcd8baee9556fb01de3fe43d87a46f985c0c1155dfb211622e0313f4ebde382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8233648e5de7b9c3c0737c142f601bea0957f273955cb2122aa05945dfbaa27"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      buildluau
      buildluau-analyze
      buildluau-ast
      buildluau-compile
      buildluau-reduce
    ]
  end

  test do
    (testpath"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}luau test.lua")
  end
end