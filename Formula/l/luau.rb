class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.714.tar.gz"
  sha256 "1c616a6631e0faf507bfb5145eced43b9ffd5a2cb86d4cb07479effc54766792"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27edf1b53ac6ea4e4fd1b0c29dfe74cf48f67fe3a4c3bab9aebc46140e19fd3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c89d5f3b3a0c746661f1322a29d2be6b0b63b4ea4fbaa009dd9c1f3caff5472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86fd73c3ab3612e3405b4cfa8843c21eea3fd2c46a094a4dc649b6d0942a8a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a93f627a2267f98f38b5933ab3f08cb38d0c460433f8cf3d44bef8be4c3b8ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a1648ee1460211048053a2b6bc06d5bb3a393b7560e837a864a7f116980f2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1f32eb25b88f348aa07ca0838dd1aa225d55ad43b07a36adc738be026b4289"
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