class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.738.tar.gz"
  sha256 "e7fa8590fff16d20f4ac0da40fe79b1fe24d489f965c60e5cb455d462bd48929"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a072e1811ba89620b6e8250ff94da5ada1229280c8643a153d2836d2715c0330"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9139916b93c82266df6dd5fd4c4f89334f5365b3b22d5d0b21f3c02709c586f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2bb99dfdcfadc1c4bb2d22eec2d636556066f11982f018878b12e90f5750e8f"
    sha256 cellar: :any,                 arm64_linux:       "904b7f558ad5a232574e5d19e5a3094f8694d2a2bf144c129a8cd5ec137248b9"
    sha256 cellar: :any,                 x86_64_linux:      "70e7c3e63fbcd88ec9eb558117a938a1c5cde87c16020a2ca4f0b5d5c2058af1"
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