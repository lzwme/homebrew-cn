class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/refs/tags/0.594.tar.gz"
  sha256 "3fdd72f8c41ee3caf9f1bb4cc0aa0ffc0d47d172ef78d3979bc20667e4b216ab"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67358a8997f4e824c63de6a5c15e0558eba44d802fa134fb767183ba0e63fc68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3995e5dd856a0280b9d43bb644d9a2b6fb7a38e276e32bfe96c6ba2193095ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28a6b1bff4b6beb8ffd93be0fa1938232a07a102d0b9d57ab56362427f597538"
    sha256 cellar: :any_skip_relocation, ventura:        "8855fb08fea656d9771e528f0b9d704cc81c046b5f0d48db5a7a0ec38f88c591"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b9e2b0190909602ed5f05d68914d9c2eb29e97f848d8bed8486f08230cc86a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ad0fe304540a1b5fb3d07e497e8418ab990f2c34b3b9ad14e49c0dc7cd96166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee221578d67e6159273f8fad29c651ea035f09e432e5a136f9ffe623475d8c4"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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