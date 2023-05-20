class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.577.tar.gz"
  sha256 "4fd3f0d7a3bb6a9f4ed69711d261c4ae6ab6dfe8eb8e444f738c3338c559c7c8"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c963a73be4bbcd36c9b7452f484421cdb9fd95d3d044bc2bcd78726949efaf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7029f0f6f0478604bb1aa06165c30f3ac24cc101e95d3d5321f5a3b96627febd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1055659da933d4ad77383a3f23d7d90063e9371a1c82ad8765671baf97a9f2a3"
    sha256 cellar: :any_skip_relocation, ventura:        "8271f25825249d64da083eb1afd30bad32544bd5ece50bf89031e0e60b2fbf4b"
    sha256 cellar: :any_skip_relocation, monterey:       "334ca07f9938a6a12bd4dff4eb71f721da946a1c6a1dfdebc135a0797d9f1385"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f325040a436c13b8bb0ae18f091b2d00b0588adf8515eec96c24c574b9e3025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "032a26b3e6a26d99d55cd73a3f68912308169e7bb68b339dde784a9de3149d86"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end