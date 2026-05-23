class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.722.tar.gz"
  sha256 "b69d7dd42540dc3892c5aa2f5c733897a8350ad64f09a0e0984a8c42ba29961b"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e74630d7602f35d0667b02bf17028680ac42c9e65ffd017c1b820fc3569aa24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b41fcc38238e4a77a6d28e034fdb7321e2f31b68c9ee44e400ce8ec4c7a3fafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17d84e0823b58f8b3fc690e79e69278bb57d3b6849303bf9d94681aa26c2945a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7736ddc5c28e3005adb7463a82b1e2b7e8fcfe45537151409026ff6e63beac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf22b530c67f233d705565ef08201c033f0f87aaa8acd9eef45201bb0ba71e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6c1df9674e7acd51fcf73f9165083b8fac0f282728b6c6be8078d9f5680a75"
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