class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://ghproxy.com/https://github.com/Roblox/luau/archive/0.592.tar.gz"
  sha256 "783c8e70dc22a336d26bc69aaaab9a717c895f2db3d3820c0a03f4849a298030"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddfae2577161fa92de7104966c678f71fde092b7d758b35fce253c0bb70f72f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76f07ff0c966e2facaa6b54a846f897716aaf0d98f8d7b4c3a1d6d88aa126c47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0070078429fa8ea05bbc956409c38cba5c91e67d70c489da9af22200a9db0207"
    sha256 cellar: :any_skip_relocation, ventura:        "3a533848ae1b72da22198569a4878393024243a82992742588c975b55169bd3c"
    sha256 cellar: :any_skip_relocation, monterey:       "deed9dd44d8b8c777fb3bfb18d1071e48304482b08cbdeb2bc62b0b0bef93ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e9b31fd3295764b8d21c5811a15a11541d4611c8b32f15c7d82e5ac4485d3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665c0f3d1e7f8847279304c2ea03c8eadcaa0ee3329334ad902c833356b44ebf"
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