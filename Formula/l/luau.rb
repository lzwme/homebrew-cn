class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.742.tar.gz"
  sha256 "c065ac4e0a7f147a5db0429163d8d4d61cd18281a83195185823d9810f0e8284"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f9e67dc54f1e7804ff14aaaa8311faf28bdef2816adab4ea9474e59924bd9a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e14f1f038aad8cbb71b249b21af6c6fa5b7a27bb2290daea77c2c2e48943a1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1851baccc49f14ad78f91b379c3ec3fa4c0a9133d79d63d6d0b73c289fc3c7d1"
    sha256 cellar: :any,                 arm64_linux:       "9d218d3e9a5e7e0fefba671d5c615d644404f89c2c5b7490d076adde694c6399"
    sha256 cellar: :any,                 x86_64_linux:      "293a8df7bcf09ddea6fd63285f6a9d08843622bbd3790a0c141ae155d7f2b7eb"
  end

  depends_on "cmake" => :build

  deny_network_access!

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