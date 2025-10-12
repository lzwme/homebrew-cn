class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.695.tar.gz"
  sha256 "15280abccdd81171236ee9f139dfd2189d2f5db10f6e50b9bf91148dae94591b"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "549b65a7a9e073805ecc988ebc19c1467ae08b08c657dacdabcd79b137d3c0a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb69c8f47109e00d2287e4541aa0e9b6c65d132033cbf525e43fbcc3df3a974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5863190b75beb746c86d0bb9dad093ae2df70b06d786f8d0e7c367b625f2556c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5639acc7e99a22704d59e07aaef55575174bf813f240f95c7eedb3cd46c18a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d011385872f49ee6186448b985ca963e01553427c0f6870bb8c2ff1661af83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d2a91b4198d44a4a6c5a88e0ceb1cd9aefca412e3720cb93eb15da52971315b"
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