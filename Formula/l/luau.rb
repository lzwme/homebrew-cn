class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.590.tar.gz"
  sha256 "942286e616edad6177f6a24a0b3bd92a8158bba9a578eb26cdee34e280f3d1ef"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da859d712648a31ca6db2297a6e742d21d918350d527f97c3468782474c3fb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96edaac44ec61b67c7723d5758c934125f2c8029ef3f64e60b9f88e22be8a772"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8692981b9e22421a17c6f3f66819b7b44dbee4d6edeab13191222dc1e68de6b4"
    sha256 cellar: :any_skip_relocation, ventura:        "db68d677111dc3da2ad8b2913e936629e43a7b223f8130b6b1def45b89c66cc6"
    sha256 cellar: :any_skip_relocation, monterey:       "ae86406b219e3280b6b3783c47b808c9f7c865523f1891b9b0394b707637b350"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8c1b79f7df65273b225661bf060a4703768cbcdd8621cfed562cd8eb0e74cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c93eb8e01204d2b1071c6f5273e36a86f215d0eb18ed066cc44be06074de87"
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