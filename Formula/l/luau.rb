class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://ghfast.top/https://github.com/luau-lang/luau/archive/refs/tags/0.740.tar.gz"
  sha256 "419f96e4ecf5a0dd415a2625ea7ea9dc8a407e86d64b25e00936302b25a7afbd"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bb133dc0f57fe95a7425867c750ef4ca083c19490f924f99707f653e65986d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "649be3620dc07bb479dc9ef8aecc2c94ef0927af38be0031b2d9e4c1f698150f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77269f7ae49392b9c589cad87fe4ed0521492f8c39ec9042f70d8f2db3ef15fd"
    sha256 cellar: :any,                 arm64_linux:       "4ca223a4b53faa736068460a2b8bd84f28c0c9ff3c689b82392682bac40a24c3"
    sha256 cellar: :any,                 x86_64_linux:      "7865921c9e00c16e908dbf2fa9b07796fbab04dc62e72c01520d16fcc67693d3"
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