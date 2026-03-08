class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.711.tar.gz"
  sha256 "aea6288c8248c62cfbf88c22405ab3ee1994a10b6d6675216b53157969198c1a"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a8d351bddac3a8e2059c9a73b07d0e957cddf611ca8fc7b508c2ac870fa158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9557b7f03057a435e08260a132e282e34fb04af0b0acd0e7989eb0679e39d122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ca69dcde6d1a593084a5002f0ca70d7ac8b881d19f9f9a9ef2d764091328132"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf5b5f062c960cdbed321fd2fb8ef4f89117434b3e50e9e985154da4445d50d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f3496f19d8603602c3070c0937db6ed0e4ab5d817f4ffe3fd81219d323eaf30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867e534dfd363b2296d1a7f40f479d6d388bfcacb3f0962b6ab471a5f0c95c1c"
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