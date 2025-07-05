class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.681.tar.gz"
  sha256 "56994c0bafb743be7f463710c59d72fc006a772c559551de5a2c3a393575e90f"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3f4a5f3d1ea04d626a3b12bdae20386533e36ac1397221fe442f086ee013d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a98dddf465dcf78730ad254866d45f4206b64847b442cb9a706f9d4f09a25555"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77349a1760b190a303e509e043402e908eeb4eaafad377ae0bb37a683c1e8b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f87ea59dada237493b694701edd92d2a0a5b6d18fe27191dacb551ceadc5dd7"
    sha256 cellar: :any_skip_relocation, ventura:       "e8cfb68e7ae6e423cddf289ddd14c4486c094aae825deb282193c113bb26ea42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35790f2bbae2461cbf06a76964c994736b893713cb6ca7d7309dfb6990ce3b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089dacff45a0f82ee3278af88d021883a626200a3e267e5c49e522f5cbcaf9de"
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